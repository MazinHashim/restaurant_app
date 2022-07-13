import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/widgets/app_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String confirmPassword;
  late bool isLoading;
  late bool _passwordVisible;
  late bool _confirmVisible;

  void submit(AuthProvider provider) {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      User user = User(5, email, password);
      provider.addUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your account is under verification')));
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, StartupScreen.routeName,
          arguments: StartupContent.signin);
      form.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    password = "";
    _passwordVisible = true;
    _confirmVisible = true;
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        titleText(),
        const SizedBox(height: 10),
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
                    icon: Icons.email),
                AppTextFormField(
                    onSaved: (String value) => password = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please Fill Password";
                      } else if (value.length < 6) {
                        return 'Please enter at least 6 characters';
                      }
                    },
                    controller: passwordController,
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
                AppTextFormField(
                    onSaved: (String value) => confirmPassword = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please Confirm Password";
                      } else if (value.length < 6) {
                        return 'Please enter at least 6 characters';
                      } else if (confirmpasswordController.text !=
                          passwordController.text) {
                        return "Password does not matches";
                      }
                    },
                    controller: confirmpasswordController,
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmVisible = !_confirmVisible;
                        });
                      },
                      child: Icon(
                        _confirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                    ),
                    lblText: "Confirm Password",
                    icon: Icons.lock_open,
                    isSecure: _confirmVisible),
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
                          child: const Text("SIGN UP",
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
                          arguments: StartupContent.signin);
                    },
                    child: const Text(
                      "Sign In instead ?",
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
      "Sign Up",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
