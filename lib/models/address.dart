class Address {
  int? _id;
  int? _postcode;
  String? _ward;
  String? _block;
  String? _buildName;
  String? _unitNumber;
  double? _latitude;
  double? _longitude;

  Address.initial() {
    _id = 0;
    _ward = "";
    _block = "";
    _buildName = "";
    _unitNumber = "";
    _latitude = 0.0;
    _longitude = 0.0;
  }

  Address(
    int? id,
    int? postcode,
    String? ward,
    String? block,
    String? buildName,
    String? unitNumber,
    double? latitude,
    double? longitude,
  ) {
    if (id != null) {
      _id = id;
    }
    if (postcode != null) {
      _postcode = postcode;
    }
    if (ward != null) {
      _ward = ward;
    }
    if (block != null) {
      _block = block;
    }
    if (buildName != null) {
      _buildName = buildName;
    }
    if (unitNumber != null) {
      _unitNumber = unitNumber;
    }
    if (latitude != null) {
      _latitude = latitude;
    }
    if (longitude != null) {
      _longitude = longitude;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id!;

  int? get postcode => _postcode;
  set postcode(int? postcode) => _postcode = postcode!;

  String? get ward => _ward;
  set ward(String? ward) => _ward = ward!;

  String? get block => _block;
  set block(String? block) => _block = block!;

  String? get buildName => _buildName;
  set buildName(String? buildName) => _buildName = buildName!;

  String? get unitNumber => _unitNumber;
  set unitNumber(String? buildName) => _unitNumber = unitNumber!;

  double? get latitude => _latitude;
  set latitude(double? latitude) => _latitude = latitude!;

  double? get longitude => _longitude;
  set longitude(double? longitude) => _longitude = longitude!;
}
