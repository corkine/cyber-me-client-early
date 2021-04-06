import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_flutter/cmgo/data.dart';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:learn_flutter/cmgo/config.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickLinkPage extends StatefulWidget {
  const QuickLinkPage();
  @override
  _QuickLinkPageState createState() => _QuickLinkPageState();
}

class _QuickLinkPageState extends State<QuickLinkPage> {
  Future<dynamic> _data;

  @override
  void initState() {
    super.initState();
  }

  Future<List<EntityLog>> fetchData(int limit) async {
    return http
        .get(Uri.parse(
            'https://go.mazhangjing.com/logs?user=corkine&password=mzj960032&day=$limit'))
        .then((value) {
      var data = jsonDecode(Utf8Codec().decode(value.bodyBytes));
      return (data as List).map((e) => EntityLog.fromJSON(e)).toList();
    });
  }

  _retry(int limit) => setState(() {
        _data = fetchData(limit);
      });

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget w) {
        _data = fetchData(config.shortURLShowLimit);
        return FutureBuilder(
            future: _data,
            builder: (b, s) {
              if (s.connectionState != ConnectionState.done)
                return Center(child: Text('正在检索数据'));
              if (s.hasError) //如果出错，state 重置，但是 data 不会重置
                return InkWell(
                    radius: 20,
                    onTap: _retry(config.shortURLShowLimit),
                    child: Center(child: Text('检索出错，点击重试')));
              if (s.hasData) {
                List<EntityLog> logs;
                if (config.filterDuplicate)
                  logs = HashMap<String, EntityLog>.fromIterable(
                      (s.data as List).reversed,
                      key: (e) => (e as EntityLog).keyword,
                      value: (e) => e).values.toList();
                else
                  logs = s.data;
                logs.sort((a, b) => -1 * a.actionTime.compareTo(b.actionTime));
                return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (c, i) => ListTile(
                        onTap: () => launch(logs[i].url),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 5, right: 8),
                          child: Icon(Icons.vpn_lock),
                        ),
                        horizontalTitleGap: 0,
                        title: RichText(
                            text: TextSpan(
                                text: logs[i].keyword,
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(
                                  text: '  ' +
                                      DateFormat('yy/M/d HH:mm')
                                          .format(logs[i].actionTime),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12))
                            ])),
                        subtitle: Text(
                          logs[i].iPInfo,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13),
                        )));
              }
              return Center(
                child: Text('没有数据'),
              );
            });
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      showSearch(context: context, delegate: ItemSearchDelegate());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Config>(
      builder: (BuildContext context, Config config, Widget widget) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Keyword'),
            toolbarHeight: config.toolBarHeight,
          ),
          body: Container(
            color: Colors.transparent,
          ),
        );
      },
    );
  }
}

class ItemSearchDelegate extends SearchDelegate<String> {
  ItemSearchDelegate()
      : super(
            searchFieldLabel: '查找或插入',
            searchFieldStyle: TextStyle(color: Colors.grey));
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          this.close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResult(query);
  }

  _insert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return AddDialog(query);
        });
  }

  _delete(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('是否确认删除 $query ？'),
            content: Text('删除操作不可撤销'),
            actions: [
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('删除', style: TextStyle(color: Colors.red))),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('取消'))
                ],
              )
            ],
          );
        }).then((value) => value ? _deleteFromWeb(context, query) : true);
  }

  _deleteFromWeb(BuildContext context, String query) {
    if (query == null || query.isEmpty) return;
    http
        .get(Uri.parse(
            'https://go.mazhangjing.com/deleteKey/$query?user=corkine&password=mzj960032'))
        .then((value) => jsonDecode(Utf8Codec().decode(value.bodyBytes)))
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${value['message']}'),
      ));
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != null && query.isNotEmpty) {
      return ListView(
        children: [
          ListTile(
            title: Text('将 $query 添加到数据库'),
            onTap: () => _insert(context),
          ),
          ListTile(
              title: Text('将 $query 从数据库删除'), onTap: () => _delete(context))
        ],
      );
    } else
      return Text('');
  }
}

class SearchResult extends StatefulWidget {
  final String keyword;
  const SearchResult(this.keyword);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  Future<dynamic> _future;

  String _word() {
    if (widget.keyword == null || widget.keyword.isEmpty)
      return 'test';
    else
      return widget.keyword;
  }

  Future<List<Entity>> _loadData() {
    return http
        .get(Uri.parse('https://go.mazhangjing.com/searchjson/${_word()}'
            '?user=corkine&password=mzj960032'))
        .then((value) =>
            (jsonDecode(Utf8Codec().decode(value.bodyBytes)) as List)
                .map((e) => Entity.fromJSON(e))
                .toList());
  }

  @override
  void initState() {
    super.initState();
  }

  _retry() => setState(() {
        _future = _loadData();
      });

  final style = TextStyle(color: Colors.black, fontSize: 16);

  Widget _buildTitle(String fullMatch) {
    final keyword = widget.keyword;
    if (keyword == null || keyword.isEmpty)
      return Text(
        fullMatch,
        style: style,
      );
    int place = fullMatch.indexOf(keyword);
    if (place == -1)
      return Text(
        fullMatch,
        style: style,
      );
    return RichText(
      text: TextSpan(
          text: fullMatch.substring(0, place),
          style: style,
          children: [
            TextSpan(
                text: keyword, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: fullMatch.substring(place + keyword.length))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _future = _loadData();
    return FutureBuilder(
        future: _future,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return Container(
              alignment: Alignment(0, -0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                  Text('  正在检索')
                ],
              ),
            );
          }
          if (s.hasError) {
            return InkWell(onTap: _retry(), child: Text('出错了，请重试'));
          }
          if (s.hasData) {
            List<Entity> data = s.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (c, i) {
                  return Dismissible(
                    key: Key(i.toString()),
                    background: Container(),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                  title: Text('确认删除 ${data[i].keyword} 吗？'),
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
                                            child: Text('确认'))
                                      ],
                                    )
                                  ],
                                )).then((value) {
                          if (value) {
                            http
                                .get(Uri.parse(
                                    'https://go.mazhangjing.com/deleteKey/${data[i].keyword}?user=corkine&password=mzj960032'))
                                .then((value) => jsonDecode(
                                    Utf8Codec().decode(value.bodyBytes)))
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('${value['message']}')));
                              return true;
                            });
                            return true;
                          } else
                            return false;
                        });
                      } else
                        return false;
                    },
                    child: ListTile(
                      title: _buildTitle(data[i].keyword),
                      subtitle: Text(data[i].redirectURL,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.clip),
                      trailing:
                          data[i].password == null ? null : Icon(Icons.lock),
                      onTap: () {
                        final url = data[i].redirectURL;
                        launch(url);
                      },
                    ),
                  );
                });
          }
          return Container(alignment: Alignment(0, -0.8), child: Text('没有数据'));
        });
  }
}

class AddDialog extends StatefulWidget {
  final String query;
  const AddDialog(this.query);
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  String _text = '';
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text('添加关键字 ${widget.query}'), children: [
      Padding(
        padding: const EdgeInsets.only(left: 19, right: 19, top: 0, bottom: 0),
        child: Text(
          '将原始地址跳转到 https://go.mazhangjing.com/${widget.query}',
          style: TextStyle(fontSize: 12),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 19, right: 19, top: 0, bottom: 10),
        child: TextField(
          decoration: InputDecoration(labelText: '原始地址'),
          onChanged: (s) {
            _text = s;
          },
        ),
      ),
      ButtonBar(
        children: [
          TextButton(onPressed: _submitData, child: Text('确定')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'))
        ],
      )
    ]);
  }

  _submitData() {
    final url = _text;
    final keywords = widget.query;
    if (url == null || url.isEmpty || keywords == null || keywords.isEmpty) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('没有数据')));
    } else
      http
          .post(Uri.parse('https://go.mazhangjing.com/add'),
              headers: {
                "content-type": "application/json",
                HttpHeaders.authorizationHeader:
                    "Basic ${base64Encode(utf8.encode('corkine:mzj960032'))}"
              },
              body: utf8.encode(json.encode({
                'keyword': keywords,
                'redirectURL': url,
                'note': 'Add by Flutter Client'
              })))
          .then((value) => jsonDecode(utf8.decode(value.bodyBytes))['message'])
          .then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())));
      });
  }
}
