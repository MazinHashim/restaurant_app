import 'package:flutter/material.dart';
import 'package:resturant_app/account/account_info.dart';
import 'package:resturant_app/startup/activated_step.dart';
import 'package:resturant_app/startup/add_billing_info.dart';
import 'package:resturant_app/startup/address_info.dart';
import 'package:resturant_app/startup/register_restaurant_info.dart';
import 'package:resturant_app/startup/signin_form.dart';
import 'package:resturant_app/startup/signup_form.dart';
import 'package:resturant_app/startup/startup_content.dart';

class StartupScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const String routeName = "/startup_screen";
  final StartupContent? paramContent;

  StartupScreen({Key? key, this.paramContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StartupContent content = paramContent ??
        ModalRoute.of(context)!.settings.arguments as StartupContent;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: 0.0, backgroundColor: Theme.of(context).primaryColor),
        body: Stack(
          children: [
            Container(
              height: 100,
              color: Theme.of(context).primaryColor,
            ),
            mainContainer(context, content)
          ],
        ));
  }

  Container mainContainer(BuildContext context, StartupContent content) {
    return Container(
      height: 610,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(blurRadius: 10, spreadRadius: 2, color: Colors.grey)
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () => FocusScope.of(context)
              .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              if (content != StartupContent.restautrantInfo &&
                  content != StartupContent.accountInfo &&
                  content != StartupContent.addressInfo)
                logoWidget(context),
              if (content == StartupContent.loadingSession)
                const Center(
                    child: Text("Welcome To Restaurant app",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 45))),
              if (content == StartupContent.signup)
                const SignUpForm()
              else if (content == StartupContent.signin)
                const SignInForm()
              else if (content == StartupContent.restautrantInfo)
                const RegisterRestaurantInfo()
              else if (content == StartupContent.addressInfo)
                const AddressInfo()
              else if (content == StartupContent.billingInfo)
                const AddBillingInfo()
              else if (content == StartupContent.activatedStep)
                const ActivatedStep()
              else if (content == StartupContent.accountInfo)
                const AccountInfo()
              else if (content == StartupContent.loadingSession)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox logoWidget(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Image.asset(
          "assets/img/logo.png",
        ),
      ),
    );
  }
}
