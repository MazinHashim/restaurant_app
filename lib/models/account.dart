import 'package:image_picker/image_picker.dart';
import 'package:resturant_app/models/closing_days.dart';

class Account {
  int? _id;
  bool? _isEnabled;
  String? _profilePic, _menuePic, _paymentType, _description;
  double? _budget;
  DateTime? _openingTime, _closingTime, _businessHours;
  List<XFile>? _restaurantImages;
  List<ClDays>? _closingDays;
  int? _userId;

  Account.initial() {
    _id = 0;
    _isEnabled = false;
    _profilePic = "";
    _menuePic = "";
    _paymentType = "";
    _openingTime = DateTime.now();
    _closingTime = DateTime.now();
    _businessHours = DateTime.now();
    _description = "";
    _userId = 0;
    _restaurantImages = [];
    _closingDays = [];
  }

  Account(
      int? id,
      bool? isEnabled,
      String? profilePic,
      String? menuePic,
      String? paymentType,
      double? budget,
      DateTime? openingTime,
      DateTime? closingTime,
      DateTime? businessHours,
      List<XFile>? restaurantImages,
      List<ClDays>? closingDays,
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
    if (menuePic != null) {
      _menuePic = menuePic;
    }
    if (paymentType != null) {
      _paymentType = paymentType;
    }
    if (budget != null) {
      _budget = budget;
    }
    if (openingTime != null) {
      _openingTime = openingTime;
    }
    if (closingTime != null) {
      _closingTime = closingTime;
    }
    if (businessHours != null) {
      _businessHours = businessHours;
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
    if (closingDays != null) {
      _closingDays = closingDays;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id!;

  bool? get isEnabled => _isEnabled;
  set isEnabled(bool? isEnabled) => _isEnabled = isEnabled!;

  String? get profilePic => _profilePic;
  set profilePic(String? profilePic) => _profilePic = profilePic!;

  String? get menuePic => _menuePic;
  set menuePic(String? menuePic) => _menuePic = menuePic!;

  String? get paymentType => _paymentType;
  set paymentType(String? paymentType) => _paymentType = paymentType!;

  double? get budget => _budget;
  set budget(double? budget) => _budget = budget!;

  DateTime? get openingTime => _openingTime;
  set openingTime(DateTime? openingTime) => _openingTime = openingTime!;

  DateTime? get businessHours => _businessHours;
  set businessHours(DateTime? businessHours) => _businessHours = businessHours!;

  DateTime? get closingTime => _closingTime;
  set closingTime(DateTime? closingTime) => _closingTime = closingTime!;

  List<ClDays>? get closingDays => _closingDays;
  set closingDays(List<ClDays>? closingDays) => _closingDays = closingDays!;

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
