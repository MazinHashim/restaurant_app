import 'package:flutter/material.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivatedStep extends StatelessWidget {
  const ActivatedStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVerfied = true;

    return !isVerfied == true
        ? activationMessage(
            "Your account is not activated, wait until verified it")
        : Column(
            children: [
              activationMessage(
                  "Resautrant inforamtion verified and your account is activated, press next to move on"),
              const SizedBox(height: 70),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("next_step", "account").then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('MOVE ON to home page Data')));
                      Navigator.pushReplacementNamed(
                          context, StartupScreen.routeName,
                          arguments: StartupContent.accountInfo);
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          );
  }

  Text activationMessage(String msg) {
    return Text(
      msg,
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
    );
  }
}
