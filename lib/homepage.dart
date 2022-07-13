import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/account/account_info.dart';
import 'package:resturant_app/account/account_page.dart';
import 'package:resturant_app/models/account.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/account_provider.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/table_management/reservation_filter.dart';
import 'package:resturant_app/table_management/restaurant_reservations.dart';
import 'package:resturant_app/table_management/tables_list.dart';
import 'package:resturant_app/widgets/image_picker_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, Object>> pages = const [
    {"title": "Tables Management", "icon": Icons.table_bar},
    {"title": "Restuarant Account", "icon": Icons.account_box},
    {"title": "New Reservations", "icon": Icons.notifications},
    {"title": "History", "icon": Icons.history}
  ];

  int? currentPage = 0;
  late User? sessionUser = User.initial();
  late Account account = Account.initial();
  late String profilePic = "";
  late bool isResAccepted = false;
  final ImagePicker picker = ImagePicker();
  late AccountProvider accProvider;

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      profilePic = pickedFile!.path;
      account.profilePic = profilePic;
    });
  }

  void getAccountForAuthUser(AccountProvider accProvider) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.getSesstionToken().then((user) {
      account = accProvider.findRestaurantAccountByUserId(user.id!);
      setState(() {
        sessionUser = user;
        isResAccepted = account.isEnabled!;
        profilePic = account.profilePic!;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accProvider = Provider.of<AccountProvider>(context, listen: false);
      getAccountForAuthUser(accProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    // accProvider = Provider.of<AccountProvider>(context);
    // getAccountForAuthUser(accProvider);
    return Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: sessionUser!.id == 0
            ? const Drawer(
                child: CircularProgressIndicator(),
              )
            : Drawer(
                child: Column(
                  children: [
                    SizedBox(
                      child: AppBar(
                          centerTitle: true,
                          elevation: 0,
                          title: Text(
                            sessionUser!.email!,
                            style: const TextStyle(
                              fontSize: 25,
                              fontFamily: "DarkerGrotesque",
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Consumer<AccountProvider>(
                          builder: (context, value, child) {
                        profilePic = value
                            .findRestaurantAccountByUserId(sessionUser!.id!)
                            .profilePic!;
                        return AppImagePicker(
                            imageFile: profilePic,
                            onChange: () {
                              takePhoto(ImageSource.gallery);
                            });
                      }),
                    ),
                    Column(
                      children: List.generate(
                          pages.length,
                          (index) => ListTile(
                              selected: currentPage == index,
                              selectedColor: Colors.black,
                              selectedTileColor: Colors.red[100],
                              title: Text(pages[index]["title"].toString()),
                              leading: Icon(pages[index]["icon"] as IconData),
                              onTap: () {
                                setState(() {
                                  currentPage = index;
                                });
                              })),
                    ),
                    ReservationToggler(
                        isResAccepted: isResAccepted,
                        onChange: (value) {
                          accProvider.toggleReservations(account.id!);
                          setState(() {
                            isResAccepted = value;
                          });
                        })
                  ],
                ),
              ),
        appBar: AppBar(
          title: const Text("Home page"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove("session_token").then((_) {
                    Navigator.pushReplacementNamed(
                        context, StartupScreen.routeName,
                        arguments: StartupContent.signin);
                  });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: sessionUser!.id == 0
            ? const Center(child: Text("Loading..."))
            : currentPage == 0
                ? TableList()
                : currentPage == 1
                    ? AccountPage(user: sessionUser!)
                    : currentPage == 2
                        ? const RestaurantReservations(
                            filter: ReservationFiler.reserved)
                        : currentPage == 3
                            ? const RestaurantReservations(
                                filter: ReservationFiler.empty)
                            : const Center(child: Text("Page Not Fount!")));
  }
}
