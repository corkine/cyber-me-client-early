import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:learn_flutter/cmpocket/config.dart';
import 'package:learn_flutter/cmpocket/data.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class GoodsHome extends StatefulWidget {
  @override
  _GoodsHomeState createState() => _GoodsHomeState();
}

class _GoodsHomeState extends State<GoodsHome> {
  Future<dynamic> _data;
  http.Client _client;

  Future<List<Good>> fetchData(Config config) async {
    return _client.get(Uri.parse(config.goodsURL())).then((value) {
      var data = jsonDecode(Utf8Codec().decode(value.bodyBytes));
      return (data as List).map((e) => Good.fromJSON(e)).toList();
    });
  }

  _retry(Config config) => setState(() {
        _data = fetchData(config);
      });

  @override
  void initState() {
    super.initState();
    _client = http.Client();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget w) {
        _data = fetchData(config);
        return FutureBuilder(
            future: _data,
            builder: (b, s) {
              if (s.connectionState != ConnectionState.done)
                return Center(child: Text('正在检索数据'));
              if (s.hasError) //如果出错，state 重置，但是 data 不会重置
                return InkWell(
                    radius: 20,
                    onTap: () => _retry(config),
                    child: Center(child: Text('检索出错，点击重试')));
              if (s.hasData) {
                final List<Good> data = s.data;
                return GoodList(config.notShowArchive
                    ? data
                        .where((element) => element.currentStateEn != 'Archive')
                        .toList()
                    : data);
              }
              return Center(
                child: Text('没有数据'),
              );
            });
      },
    );
  }
}

class GoodList extends StatelessWidget {
  final List<Good> goods;
  const GoodList(this.goods);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: goods.length,
        itemBuilder: (c, i) => Dismissible(
              key: Key(i.toString()),
              background: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('这里什么也没有...'),
                    )
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    SizedBox(width: 30)
                  ],
                ),
              ),
              confirmDismiss: (d) => _handleDismiss(d, goods[i], context),
              child: Card(
                child: Stack(children: [
                  Opacity(
                    opacity: 0.2,
                    child: Container(
                      color: goods[i].picture != null ? null : Colors.blueGrey,
                      decoration: goods[i].picture != null
                          ? BoxDecoration(
                              image: DecorationImage(
                              image: NetworkImage(goods[i].picture),
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(
                                  Colors.white12, BlendMode.color),
                              alignment: Alignment(0, -0.5),
                            ))
                          : null,
                      width: double.infinity,
                      height: 100,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return GoodAdd(goods[i]);
                      }));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 100,
                      child: ListTile(
                        tileColor: Colors.transparent,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5, right: 9),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey.shade200,
                            foregroundColor: Colors.white,
                            child: Text(
                                goods[i].name.substring(0, 1).toUpperCase()),
                          ),
                        ),
                        horizontalTitleGap: 0,
                        title: RichText(
                            text: TextSpan(
                                text: goods[i].name,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                              TextSpan(
                                  text: '  ' +
                                      DateFormat('yy/M/d')
                                          .format(goods[i].updateTime),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12))
                            ])),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white54),
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, top: 1, bottom: 1),
                              child: Text(goods[i].importance +
                                  ' | ' +
                                  goods[i].currentState),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                goods[i].description ?? '',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        trailing: null,
                      ),
                    ),
                  )
                ]),
              ),
            ));
  }

  Future<bool> _handleDismiss(DismissDirection direction,
      Good good, BuildContext context) async {
    if (direction == DismissDirection.startToEnd) return false;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) => AlertDialog(
              title: Text('确认删除 ${good.name} 吗？'),
              content: Text('此操作不可取消'),
              actions: [
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('取消')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          '确认',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                )
              ],
            )).then((value) {
      if (value) {
        http
            .get(Uri.parse(Config.deleteGoodsURL(good.id)))
            .then((value) => jsonDecode(Utf8Codec().decode(value.bodyBytes)))
            .then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${value['message']}')));
          return true;
        });
        return true;
      } else
        return false;
    });
  }
}

class GoodAdd extends StatefulWidget {
  final Good good;
  const GoodAdd(this.good);
  @override
  _GoodAddState createState() => _GoodAddState();
}

class _GoodAddState extends State<GoodAdd> {
  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  MultipartRequest request;
  File _image;

  @override
  void initState() {
    super.initState();
    _resetRequest();
  }

  @override
  Widget build(BuildContext context) {
    final good = widget.good;
    return Scaffold(
      appBar: AppBar(
        title: Text(good == null ? '添加物品' : '修改物品'),
        toolbarHeight: Config.toolBarHeight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: buildForm(context),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    final good = widget.good;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: good == null ? '' : good.id.replaceFirst('CM', ''),
            autocorrect: false,
            decoration: InputDecoration(
                labelText: '编号*',
                helperText: '编号必须以 CM 开头',
                prefixText: 'CM',
                helperStyle: Config.formHelperStyle),
            validator: (v) => (v.isNotEmpty) ? null : '编号必须以 CM 开头，不可为空',
            onSaved: (d) =>
                request.fields[good == null ? 'goodId' : 'newGoodId'] =
                    'CM' + d.toUpperCase(),
          ),
          SizedBox(height: 7),
          TextFormField(
            initialValue: good == null ? '' : good.name,
            autocorrect: false,
            decoration: InputDecoration(
                labelText: '名称*',
                helperText: '简短描述物品信息',
                helperStyle: Config.formHelperStyle),
            validator: (v) => (v.isNotEmpty) ? null : '名称不可为空',
            onSaved: (d) => request.fields['name'] = d,
          ),
          SizedBox(height: 7),
          TextFormField(
            initialValue: good == null ? '' : good.description ?? '',
            autocorrect: false,
            decoration: InputDecoration(labelText: '描述'),
            onSaved: (d) => d != null && d.isNotEmpty
                ? request.fields['description'] = d
                : null,
          ),
          SizedBox(height: 17),
          DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: '状态*'),
              value: good == null ? 'Active' : good.currentStateEn ?? 'Active',
              onChanged: (e) {},
              hint: Text('选择物品所处状态'),
              onSaved: (d) => d != null && d.isNotEmpty
                  ? request.fields['currentState'] = d
                  : null,
              items: [
                DropdownMenuItem<String>(
                  child: Text('活跃'),
                  value: 'Active',
                ),
                DropdownMenuItem<String>(
                  child: Text('普通'),
                  value: 'Ordinary',
                ),
                DropdownMenuItem<String>(
                  child: Text('不活跃'),
                  value: 'NotActive',
                ),
                DropdownMenuItem<String>(
                  child: Text('归档'),
                  value: 'Archive',
                ),
                DropdownMenuItem<String>(
                  child: Text('移除'),
                  value: 'Remove',
                ),
                DropdownMenuItem<String>(
                  child: Text('外借'),
                  value: 'Borrow',
                ),
                DropdownMenuItem<String>(
                  child: Text('丢失'),
                  value: 'Lost',
                ),
              ]),
          SizedBox(height: 7),
          DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: '级别*'),
              value: good == null ? 'A' : good.importance ?? 'A',
              onChanged: (e) {},
              onSaved: (d) => d != null && d.isNotEmpty
                  ? request.fields['importance'] = d
                  : null,
              hint: Text('选择物品所处状态'),
              items: [
                DropdownMenuItem<String>(
                  child: Text('非常重要 '),
                  value: 'A',
                ),
                DropdownMenuItem<String>(
                  child: Text('很重要'),
                  value: 'B',
                ),
                DropdownMenuItem<String>(
                  child: Text('比较重要'),
                  value: 'C',
                ),
                DropdownMenuItem<String>(
                  child: Text('有些重要'),
                  value: 'D',
                ),
                DropdownMenuItem<String>(
                  child: Text('不重要'),
                  value: 'N',
                )
              ]),
          SizedBox(height: 7),
          TextFormField(
            initialValue: good == null ? '' : good.place ?? '',
            autocorrect: false,
            decoration: InputDecoration(
                labelText: '位置',
                helperText: '物品一般放置位置',
                helperStyle: Config.formHelperStyle),
            onSaved: (d) =>
                d != null && d.isNotEmpty ? request.fields['place'] = d : null,
          ),
          SizedBox(height: 7),
          TextFormField(
            initialValue: good == null ? '' : good.message ?? '',
            autocorrect: false,
            decoration: InputDecoration(
                labelText: '消息',
                helperText: '他人扫码可见内容',
                helperStyle: Config.formHelperStyle),
            onSaved: (d) => d != null && d.isNotEmpty
                ? request.fields['message'] = d
                : null,
          ),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 0),
                  child: TextButton(
                    onPressed: _handleFetch,
                    child: Row(
                      children: [
                        Icon(good == null
                            ? _image == null
                                ? Icons.photo_camera
                                : Icons.remove_circle_outline
                            : Icons.photo_camera),
                        SizedBox(width: 6),
                        Text(good == null
                            ? _image == null
                                ? '拍摄物品照片'
                                : '删除所选照片'
                            : good.picture == null
                                ? '补充添加照片'
                                : '更新所选照片')
                      ],
                    ),
                  )),
              good == null
                  ? _image != null
                      ? Image.file(_image, width: 100)
                      : SizedBox(
                          height: 1,
                          width: 1,
                        )
                  : good.picture == null
                      ? _image == null
                          ? SizedBox(
                              height: 1,
                              width: 1,
                            )
                          : Image.file(
                              _image,
                              width: 100,
                            )
                      : Image.network(good.picture, width: 100),
            ],
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('返回/取消')),
              ElevatedButton(
                  onPressed: _savingData,
                  child: Text(good == null ? '创建' : '更新')),
            ],
          )
        ],
      ),
    );
  }

  _resetRequest() {
    request = http.MultipartRequest(
        'POST',
        Uri.parse(widget.good == null
            ? Config.goodsAddURL
            : Config.goodsUpdateURL(widget.good.id)));
    request.fields.clear();
  }

  _handleFetch() async {
    if (_image == null) {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);
      File image;
      if (pickedFile != null) {
        print(pickedFile.path);
        image = await compressAndGetFile(
            File(pickedFile.path),
            pickedFile.path
                .replaceFirst('image_picker', 'compressed_image_picker'));
        setState(() {
          _image = image;
        });
      }
    } else {
      setState(() {
        _image = null;
      });
    }
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: 640,
      minWidth: 480,
      quality: 100,
    );
    print(
        'File length ${file.lengthSync()}, Compressed to ${result.lengthSync()}');
    return result;
  }

  _savingData() async {
    var failed = true;
    if (formKey.currentState.validate()) {
      try {
        formKey.currentState.save();
        print(request.fields);
        if (_image != null) {
          //新建，有新图片 或者 修改，更新图片。当新建时没有添加图片，或者修改图片未更改，则不做处理。
          final file =
              await http.MultipartFile.fromPath('picture', _image.path);
          request.files.add(file);
        }
        //request.headers[HttpHeaders.authorizationHeader] = Config.base64Token;
        final response = await request.send();
        final data = await response.stream.toBytes();
        print(utf8.decode(data));
        Map<String, dynamic> result = jsonDecode(utf8.decode(data));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result['message'])));
        Navigator.of(context).pop();
        final model = Provider.of<Config>(context,listen: false);
        model.justNotify();
        failed = false;
        return result;
      } finally {
        _resetRequest();
        if (failed)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('上传失败')));
      }
    }
  }
}
