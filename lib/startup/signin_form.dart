import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/homepage.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late bool isLoading;
  late bool _passwordVisible;

  void submit(AuthProvider provider) async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });

      User user = provider.findUserByEmailAndPassword(email, password);
      if (user.email!.isNotEmpty) {
        if (!user.isVerified!) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please verify your email')));
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("session_token", user.email!).then((_) async {
            // check weather user has activated account then navigate it to home page
            if (!user.isActivated!) {
              await prefs.setString("next_step", "restaurant").then((_) {
                Navigator.pushReplacementNamed(context, StartupScreen.routeName,
                    arguments: StartupContent.restautrantInfo);
              });
            } else {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            }
          });
        }
        form.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email or password is wrong...')));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    password = "";
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        titleText(),
        const SizedBox(
          height: 20,
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                    onSaved: (String value) => email = value,
                    onValidate: (String emailValue) {
                      if (emailValue.isEmpty) {
                        return "Please Fill Email";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailValue)) {
                        return "incorrect email format";
                      }
                    },
                    lblText: "Email",
                    icon: Icons.email,
                    isSecure: false),
                AppTextFormField(
                    onSaved: (String value) => password = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please Fill Password";
                      } else if (value.length < 6) {
                        return 'Please enter at least 6 characters';
                      }
                    },
                    suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        )),
                    lblText: "Password",
                    icon: Icons.lock,
                    isSecure: _passwordVisible),
                const SizedBox(height: 10),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: !isLoading
                      ? ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {
                            submit(provider);
                          },
                          child: const Text("SIGN IN",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, StartupScreen.routeName,
                          arguments: StartupContent.signup);
                    },
                    child: const Text(
                      "Sign Up instead ?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }

  Text titleText() {
    return const Text(
      "Sign In",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
