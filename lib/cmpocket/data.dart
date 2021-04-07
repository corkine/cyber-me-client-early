class EntityLog {
  String iPInfo;
  String keyword;
  String url;
  int entityId;
  String visitorIP;
  DateTime actionTime;
  EntityLog.fromJSON(Map<String, dynamic> map)
      : iPInfo = _fetchInfo(map),
        keyword = map['keyword'],
        url = map['url'],
        entityId = int.tryParse(map['entityLog']['entityId'].toString()),
        visitorIP = map['entityLog']['visitorIP'],
        actionTime = DateTime.parse(map['entityLog']['actionTime']);
  static String _fetchInfo(Map<String, dynamic> map) {
    var data = map['ipInfo']
        .toString()
        .replaceAll('|', ' ')
        .replaceFirst('0', '')
        .replaceFirst('中国', '')
        .trimLeft();
    var list = data.split(' ');
    if (list.length >= 2 && list[1].contains(list[0])) {
      list.removeAt(0);
      return list.join(' ');
    } else
      return data;
  }
}

class Entity {
  String keyword;
  String redirectURL;
  String note;
  DateTime updateTime;
  int id;
  String password;
  Entity.fromJSON(Map<String, dynamic> map)
      : keyword = map['keyword'],
        redirectURL = map['redirectURL'],
        note = map['note'],
        updateTime = DateTime.parse(map['updateTime']),
        id = int.parse(map['id'].toString()),
        password = _parsePassword(map);
  static _parsePassword(Map<String, dynamic> map) {
    final ans = map['note'].toString();
    if (ans != null && ans.startsWith('MS') && ans.endsWith('MS'))
      return ans.substring(2, ans.length - 2);
    else
      return null;
  }
}

class Good {
  String id;
  String name;
  String description;
  String currentState;
  String currentStateEn;
  String importance;
  String place;
  String message;
  String picture;
  DateTime addTime;
  DateTime updateTime;
  Good.fromJSON(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        currentStateEn = map['currentState'],
        currentState = _handleState(map),
        importance = map['importance'],
        place = map['place'],
        picture = _handlePicture(map),
        message = map['message'],
        addTime = DateTime.parse(map['addTime']),
        updateTime = DateTime.parse(map['updateTime']);
  static _handlePicture(Map<String, dynamic> map) {
    final res = map['picture'].toString().replaceFirst('http://', 'https://');
    if (res == null || res.isEmpty || res.trim() == 'null')
      return null;
    else
      return res;
  }

  static _handleState(Map<String, dynamic> map) {
    final res = map['currentState'].toString();
    if (res == null || res.isEmpty || res.trim() == 'null') return null;
    switch (res.toUpperCase()) {
      case 'ACTIVE':
        return '活跃';
      case 'ARCHIVE':
        return '收纳';
      case 'ORDINARY':
        return '普通';
      case 'BORROW':
        return '外借';
      default:
        return res;
    }
  }
}
