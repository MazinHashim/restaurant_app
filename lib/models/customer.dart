class Customer {
  int? _id;
  String? _name;
  String? _phone;
  String? _profilePic;
  List<String>? _foodPreferences;
  int? _noOfPeoples;
  int? _visitCount;
  String? _status;

  Customer(
      int? id,
      String? name,
      String? phone,
      String? profilePic,
      List<String>? foodPreferences,
      int? noOfPeoples,
      int? visitCount,
      String? status) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (profilePic != null) {
      _profilePic = profilePic;
    }
    if (foodPreferences != null) {
      _foodPreferences = foodPreferences;
    }
    if (noOfPeoples != null) {
      _noOfPeoples = noOfPeoples;
    }
    if (visitCount != null) {
      _visitCount = visitCount;
    }
    if (status != null) {
      _status = status;
    }
  }

  int? get id => _id!;
  set id(int? id) => _id = id;

  String? get name => _name!;
  set name(String? name) => _name = name;
  String? get phone => _phone!;
  set phone(String? phone) => _phone = phone;
  String? get profilePic => _profilePic!;
  set profilePic(String? profilePic) => _profilePic = profilePic;
  List<String>? get foodPreferences => _foodPreferences!;
  set foodPreferences(List<String>? foodPreferences) =>
      _foodPreferences = foodPreferences;
  int? get noOfPeoples => _noOfPeoples!;
  set noOfPeoples(int? noOfPeoples) => _noOfPeoples = noOfPeoples;
  int? get visitCount => _visitCount!;
  set visitCount(int? visitCount) => _visitCount = visitCount;
  String? get status => _status!;
  set status(String? status) => _status = status;

  // Customer.fromJson(Map<String, dynamic> json) {
  //   _name = json['name'];
  //   _phone = json['phone'];
  //   _profilePic = json['profilePic'];
  //   _foodPreferences = json['foodPreferences'].cast<String>();
  //   _noOfPeoples = json['noOfPeoples'];
  //   _visitCount = json['visitCount'];
  //   _status = json['status'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = this._name;
  //   data['phone'] = this._phone;
  //   data['profilePic'] = this._profilePic;
  //   data['foodPreferences'] = this._foodPreferences;
  //   data['noOfPeoples'] = this._noOfPeoples;
  //   data['visitCount'] = this._visitCount;
  //   data['status'] = this._status;
  //   return data;
  // }
}
