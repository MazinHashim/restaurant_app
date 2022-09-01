import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/homepage.dart';
import 'package:resturant_app/providers/account_provider.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/table_management/restaurant_reservations.dart';
import 'package:resturant_app/table_management/tables_list.dart';
import 'package:resturant_app/table_management/tables_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isStartUp;
  StartupContent? currentContent;
  SharedPreferences? prefs;

  void delayFu() async {
    prefs = await SharedPreferences.getInstance();
    String? currentStep = prefs!.getString("next_step");
    String? loggedIn = prefs!.getString("session_token");

    switch (currentStep) {
      case "restaurant":
        currentContent = StartupContent.restautrantInfo;
        break;
      case "addressing":
        currentContent = StartupContent.addressInfo;
        break;
      case "billing":
        currentContent = StartupContent.billingInfo;
        break;
      case "activate":
        currentContent = StartupContent.activatedStep;
        break;
      case "account":
        currentContent = StartupContent.accountInfo;
        break;
      default:
        if (loggedIn == null) {
          currentContent = StartupContent.signin;
          break;
        }
        isStartUp = false;
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    currentContent = StartupContent.loadingSession;
    isStartUp = true;
    delayFu();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TableProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => AccountProvider()),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: "DarkerGrotesque"),
            ),
            primarySwatch: Colors.pink,
            primaryColor: const Color(0xFFF13B46),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF13B46))),
        home: isStartUp!
            ? StartupScreen(paramContent: currentContent)
            : const HomePage(),
        // home: const TableReservations(),
        routes: {
          StartupScreen.routeName: (ctx) => StartupScreen(),
          HomePage.routeName: (ctx) => const HomePage(),
          TableManagement.routeName: (ctx) => const TableManagement(),
          TableList.routeName: (ctx) => TableList(),
          RestaurantReservations.routeName: (ctx) =>
              const RestaurantReservations()
        },
      ),
    );
  }
}
