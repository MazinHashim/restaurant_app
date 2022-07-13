import 'package:image_picker/image_picker.dart';

class Account {
  int? _id;
  bool? _isEnabled;
  String? _profilePic, _paymentType, _description;
  double? _budget;
  double? _latitude;
  double? _longitude;
  DateTime? _openingTime, _closingTime;
  List<XFile>? _restaurantImages;
  int? _userId;

  Account.initial() {
    _id = 0;
    _isEnabled = false;
    _profilePic = "";
    _paymentType = "";
    _budget = 0.0;
    _latitude = 0.0;
    _longitude = 0.0;
    _openingTime = DateTime.now();
    _closingTime = DateTime.now();
    _description = "";
    _userId = 0;
    _restaurantImages = [];
  }

  Account(
      int? id,
      bool? isEnabled,
      String? profilePic,
      String? paymentType,
      double? budget,
      double? latitude,
      double? longitude,
      DateTime? openingTime,
      DateTime? closingTime,
      List<XFile>? restaurantImages,
      String? description,
      int? userId) {
    if (id != null) {
      _id = id;
    }
    if (isEnabled != null) {
      _isEnabled = isEnabled;
    }
    if (profilePic != null) {
      _profilePic = profilePic;
    }
    if (paymentType != null) {
      _paymentType = paymentType;
    }
    if (budget != null) {
      _budget = budget;
    }
    if (latitude != null) {
      _latitude = latitude;
    }
    if (longitude != null) {
      _longitude = longitude;
    }
    if (openingTime != null) {
      _openingTime = openingTime;
    }
    if (closingTime != null) {
      _closingTime = closingTime;
    }
    if (description != null) {
      _description = description;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (restaurantImages != null) {
      _restaurantImages = restaurantImages;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id!;

  bool? get isEnabled => _isEnabled;
  set isEnabled(bool? isEnabled) => _isEnabled = isEnabled!;
  String? get profilePic => _profilePic;
  set profilePic(String? profilePic) => _profilePic = profilePic!;
  String? get paymentType => _paymentType;
  set paymentType(String? paymentType) => _paymentType = paymentType!;
  double? get budget => _budget;
  set budget(double? budget) => _budget = budget!;

  double? get latitude => _latitude;
  set latitude(double? latitude) => _latitude = latitude!;

  double? get longitude => _longitude;
  set longitude(double? longitude) => _longitude = longitude!;
  DateTime? get openingTime => _openingTime;
  set openingTime(DateTime? openingTime) => _openingTime = openingTime!;
  DateTime? get closingTime => _closingTime;
  set closingTime(DateTime? closingTime) => _closingTime = closingTime!;
  List<XFile>? get restaurantImages => _restaurantImages;
  set restaurantImages(List<XFile>? restaurantImages) =>
      _restaurantImages = restaurantImages!;
  String? get description => _description;
  set description(String? description) => _description = description!;
  int? get userId => _userId!;
  set userId(int? userId) => _userId = userId;
  // Account.fromJson(Map<String, dynamic> json) {
  //   _isEnabled = json['isEnabled'];
  //   _profilePic = json['profilePic'];
  //   _paymentType = json['paymentType'];
  //   _budget = json['budget'];
  //   _openingTime = json['openingTime'];
  //   _closingTime = json['closingTime'];
  //   _restaurantImages = json['restaurantImages'].cast<String>();
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['isEnabled'] = this._isEnabled;
  //   data['profilePic'] = this._profilePic;
  //   data['paymentType'] = this._paymentType;
  //   data['budget'] = this._budget;
  //   data['openingTime'] = this._openingTime;
  //   data['closingTime'] = this._closingTime;
  //   data['restaurantImages'] = this._restaurantImages;
  //   return data;
  // }
}
