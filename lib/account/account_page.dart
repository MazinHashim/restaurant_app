import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/account/account_info.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/change_password.dart';
import 'package:resturant_app/startup/register_restaurant_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late int selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = 0;
  }

  Future<User> getSesstionToken() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return authProvider.findUserByEmail(prefs.getString("session_token"))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild),
        child: SingleChildScrollView(
          child: widget.user.id == 0
              ? const Center(child: Text("Loading..."))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: selectedPage == 0
                      ? AccountInfo(isEdition: true, user: widget.user)
                      : selectedPage == 1
                          ? RegisterRestaurantInfo(
                              isEdition: true, user: widget.user)
                          : ChangePassword(user: widget.user),
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (index) {
          selectedPage = index;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Account Info",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: "Restaurant Info",
              backgroundColor: Colors.amberAccent),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: "Change Password",
          )
        ],
      ),
    );
  }
}
