class User {
  int? _id = 0;
  String? _email, _password = "";
  bool? _isVerified, _isActivated = false;
  User.initial();
  User(int? id, String? email, String? password) {
    if (id != null) {
      _id = id;
    }
    if (email != null) {
      _email = email;
    }
    if (password != null) {
      _password = password;
    }
    _isActivated = false;
    _isVerified = false;
  }

  int? get id => _id!;
  set id(int? id) => _id = id;

  bool? get isVerified => _isVerified!;
  set isVerified(bool? isVerified) => _isVerified = isVerified;

  bool? get isActivated => _isActivated!;
  set isActivated(bool? isActivated) => _isActivated = isActivated;

  String? get email => _email!;
  set email(String? email) => _email = email;

  String? get password => _password!;
  set password(String? password) => _password = password;
}
