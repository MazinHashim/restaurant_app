class Restaurant {
  int? _id, _pastalCode, _userId = 0;
  String? _name, _phone, _category, _homeUrl, _permitPic = "";
  Restaurant.initial() {
    _phone = "";
    _name = "";
    _category = "";
    _homeUrl = "";
    _permitPic = "";
    _id = 0;
    _pastalCode = 0;
    _userId = 0;
  }
  Restaurant(int? id, String? name, int? pastalCode, String? phone,
      String? category, String? homeUrl, String? permitPic, int? userId) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (pastalCode != null) {
      _pastalCode = pastalCode;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (category != null) {
      _category = category;
    }
    if (homeUrl != null) {
      _homeUrl = homeUrl;
    }
    if (permitPic != null) {
      _permitPic = permitPic;
    }
    if (userId != null) {
      _userId = userId;
    }
  }

  int? get id => _id!;
  set id(int? id) => _id = id;

  int? get userId => _userId!;
  set userId(int? userId) => _userId = userId;

  String? get name => _name!;
  set name(String? name) => _name = name;
  int? get pastalCode => _pastalCode!;
  set pastalCode(int? pastalCode) => _pastalCode = pastalCode;
  String? get phone => _phone!;
  set phone(String? phone) => _phone = phone;
  String? get category => _category!;
  set category(String? category) => _category = category;
  String? get homeUrl => _homeUrl!;
  set homeUrl(String? homeUrl) => _homeUrl = homeUrl;
  String? get permitPic => _permitPic!;
  set permitPic(String? permitPic) => _permitPic = permitPic;

  // Restaurant.fromJson(Map<String, dynamic> json) {
  //   _id = json['id'];
  //   _name = json['name'];
  //   _pastalCode = json['pastalCode'];
  //   _phone = json['phone'];
  //   _category = json['category'];
  //   _homeUrl = json['homeUrl'];
  //   _permitPic = json['permitPic'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this._id;
  //   data['name'] = this._name;
  //   data['pastalCode'] = this._pastalCode;
  //   data['phone'] = this._phone;
  //   data['category'] = this._category;
  //   data['homeUrl'] = this._homeUrl;
  //   data['permitPic'] = this._permitPic;
  //   return data;
  // }
}
