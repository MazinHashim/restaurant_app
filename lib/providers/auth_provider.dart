import 'package:flutter/cupertino.dart';
import 'package:resturant_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final List<User> _users = [
    User(1, "def@gmail.com", "123456"),
    User(2, "xyz@gmail.com", "123456")
  ];

  List<User> get users {
    return [..._users];
  }

  Future<User> getSesstionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return findUserByEmail(prefs.getString("session_token"))!;
  }

  User? findUserByEmail(String? email) {
    return _users.firstWhere((user) => user.email == email,
        orElse: () => User(0, "", ""));
  }

  void addUser(User user) {
    _users.add(user);
  }

  void changePassword(User user, String newPassword) {
    user = _users.firstWhere((us) {
      return user.id == us.id;
    });
    user.password = newPassword;
  }

  User findUserByEmailAndPassword(String email, String password) {
    User user = _users.firstWhere(
        (user) => user.email == email && user.password! == password,
        orElse: () => User(0, "", ""));
    user.isActivated = false;
    user.isVerified = true;
    return user;
  }
}
