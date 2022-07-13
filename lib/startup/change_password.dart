import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/widgets/app_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String username;
  late String oldPassword;
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

      provider.changePassword(widget.user!, password);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your password changed successfully')));
      setState(() {
        isLoading = false;
      });
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
                    onSaved: (String value) => oldPassword = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please fill old password";
                      } else if (value.length < 6) {
                        return 'Please enter at least 6 characters';
                      } else if (value != widget.user!.password!) {
                        return 'You entered wrong password';
                      }
                    },
                    lblText: "Old Password",
                    icon: Icons.lock_open),
                AppTextFormField(
                    onSaved: (String value) => password = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please fill new password";
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
                    lblText: "New Password",
                    icon: Icons.lock,
                    isSecure: _passwordVisible),
                AppTextFormField(
                    onSaved: (String value) => confirmPassword = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please confirm new password";
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
                    lblText: "Confirm new password",
                    icon: Icons.lock,
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
                          onPressed: () => submit(provider),
                          child: const Text("CHANGE",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                ),
              ],
            )),
      ],
    );
  }

  Text titleText() {
    return const Text(
      "Change Password",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
