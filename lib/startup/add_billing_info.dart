import 'package:flutter/material.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBillingInfo extends StatefulWidget {
  const AddBillingInfo({Key? key}) : super(key: key);

  @override
  State<AddBillingInfo> createState() => _AddBillingInfoState();
}

class _AddBillingInfoState extends State<AddBillingInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late bool isLoading;
  late bool _passwordVisible;

  void submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Billing Data...')));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("next_step", "activate").then((_) {
        Navigator.pushReplacementNamed(context, StartupScreen.routeName,
            arguments: StartupContent.activatedStep);
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
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: submit,
                          child: const Text("SEND",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
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
      "Billing Information",
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}
