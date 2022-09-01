import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/restaurant.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/account_provider.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/widgets/app_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturant_app/widgets/image_picker_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterRestaurantInfo extends StatefulWidget {
  final User? user;
  final bool isEdition;
  const RegisterRestaurantInfo({Key? key, this.isEdition = false, this.user})
      : super(key: key);

  @override
  State<RegisterRestaurantInfo> createState() => _RegisterRestaurantInfoState();
}

class _RegisterRestaurantInfoState extends State<RegisterRestaurantInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();
  late bool isLoading;
  late List<String> categoryItem = [];
  late AuthProvider authProvider;
  late AccountProvider accProvider;
  late Restaurant? restaurant = Restaurant.initial();

  void submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });

      if (!widget.isEdition) {
        authProvider.getSesstionToken().then((user) {
          restaurant!.userId = user.id;
          accProvider.addRestaurant(restaurant!);
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("next_step", "addressing").then((_) {
          Navigator.pushReplacementNamed(context, StartupScreen.routeName,
              arguments: StartupContent.addressInfo);
        });
      } else {
        accProvider.updateRestaurant(restaurant!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: const Text('Updating Restaurant Data...')));
      }
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
    categoryItem.addAll([
      "Japanese",
      "Izakaya",
      "Yakitori",
      "Japanese BBQ",
      "Seafood",
      "Sushi",
      "Tempura",
      "Noodles",
      "Rice bowls",
      "Pizza",
      "Pasta",
      "Korean",
      "Chinese",
      "Mexican",
      "American",
      "Indian",
      "Vietnamese",
      "Thai",
      "Spanish",
      "Italian",
      "French",
      "Jamaican",
      "Brazilian",
      "Turkish",
      "Irish",
      "Western",
      "South American",
      "Asian",
      "African",
      "Cafe",
      "Bakery",
      "Bar"
    ]);
  }

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      restaurant!.permitPic = pickedFile!.path;
    });
  }

  @override
  void didChangeDependencies() {
    authProvider = Provider.of<AuthProvider>(context);
    accProvider = Provider.of<AccountProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdition) {
      restaurant = accProvider.findRestaurantByUserId(widget.user!.id!);
    }
    return Column(
      children: [
        titleText(),
        const SizedBox(height: 40),
        Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                    initialValue: restaurant!.name ?? "",
                    onSaved: (String value) => restaurant!.name = value,
                    onValidate: (String restaurantName) {
                      if (restaurantName.isEmpty) {
                        return "Please fill restaurant name";
                      }
                    },
                    lblText: "Restaurant Name *",
                    icon: Icons.restaurant),
                AppTextFormField(
                    initialValue: restaurant!.phone ?? "",
                    onSaved: (String value) => restaurant!.phone = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please fill phone number";
                      } else if (value.length < 10) {
                        return 'Please enter at least 10 characters';
                      }
                    },
                    keyboardType: TextInputType.phone,
                    lblText: "Phone Number *",
                    icon: Icons.phone),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(5)),
                  child: Stack(
                    children: [
                      if (restaurant!.category!.isEmpty)
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(children: [
                              Icon(Icons.food_bank_rounded,
                                  color: Colors.grey[600], size: 30),
                              const SizedBox(width: 10),
                              const Text("Category of food *",
                                  style: TextStyle(fontSize: 18)),
                            ])),
                      DropdownSearch<String>(
                        items: categoryItem,
                        selectedItem: restaurant!.category ?? "",
                        popupProps: const PopupProps.menu(
                            title: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Category Of Food",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                            ),
                            searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                    hintText: "Search",
                                    contentPadding: EdgeInsets.all(0))),
                            showSearchBox: true),
                        onChanged: (value) {
                          setState(() {
                            restaurant!.category = value;
                          });
                        },
                        dropdownBuilder: (context, value) {
                          return Text(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please select your category";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                AppTextFormField(
                    initialValue: restaurant!.homeUrl ?? "",
                    onSaved: (String value) => restaurant!.homeUrl = value,
                    onValidate: (String value) {},
                    lblText: "Homepage Url",
                    keyboardType: TextInputType.url,
                    icon: Icons.link),
                const SizedBox(height: 10),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 0))
                      ]),
                  child: ListTile(
                    onTap: () async {
                      takePhoto(ImageSource.gallery);
                    },
                    title: const Text("Upload Business Permition"),
                    textColor: Theme.of(context).primaryColor,
                    iconColor: Theme.of(context).primaryColor,
                    trailing: const Icon(Icons.add_photo_alternate),
                  ),
                ),
                if (restaurant!.permitPic!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 0))
                      ],
                      color: Colors.white,
                    ),
                    child: Image.file(
                      File(restaurant!.permitPic!),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                          onPressed: () => submit(),
                          child: Text(widget.isEdition ? "EDIT" : "NEXT",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
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

  Padding titleText() {
    return const Padding(
      padding: EdgeInsets.only(top: 22.0),
      child: Text(
        "Restaurant Informaition",
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
