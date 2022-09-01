import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/homepage.dart';
import 'package:resturant_app/models/account.dart';
import 'package:resturant_app/models/closing_days.dart';
import 'package:resturant_app/models/table_seats.dart';
import 'package:resturant_app/models/user.dart';
import 'package:resturant_app/providers/account_provider.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/providers/tables_provider.dart';
import 'package:resturant_app/widgets/app_text_field.dart';
import 'package:resturant_app/widgets/image_picker_widget.dart';
import 'package:resturant_app/widgets/tables_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfo extends StatefulWidget {
  final bool isEdition;
  final User? user;
  const AccountInfo({Key? key, this.isEdition = false, this.user})
      : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Position? currentPosition;
  // StreamSubscription<Position>? positionStream;

  late bool isLoading;
  late bool isLunDin;
  String? errMsg;
  late AuthProvider authProvider;
  late AccountProvider accProvider;
  late List<TableSeats> tableTypes = [];
  late Account? account = Account.initial();

  final ImagePicker picker = ImagePicker();
  late Map<ClDays, bool> daysValues = {};

  void submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      if (account!.paymentType!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: const Text('Select payment type')));
      } else {
        form.save();
        setState(() {
          isLoading = true;
        });

        if (!widget.isEdition) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          authProvider.getSesstionToken().then((user) {
            account!.userId = user.id;
            accProvider.addRestaurantAccount(account!);
            prefs.remove("next_step").then((_) {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            });
          });
        } else {
          accProvider.updateRestaurantAccount(account!);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Account Data...')));
        }
        setState(() {
          isLoading = false;
        });
        form.reset();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isLunDin = false;
    tableTypes = [];
    daysValues = {
      ClDays.Monday: false,
      ClDays.Tuesday: false,
      ClDays.Wedesday: false,
      ClDays.Thursday: false,
      ClDays.Friday: false,
      ClDays.Saturday: false,
      ClDays.Sunday: false,
      ClDays.Holidays: false
    };
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
      account = accProvider.findRestaurantAccountByUserId(widget.user!.id!);
      for (ClDays day in account!.closingDays!) {
        if (daysValues.containsKey(day)) {
          daysValues[day] = true;
        }
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        titleText(),
        const SizedBox(height: 20),
        AppImagePicker(
            imageFile: account!.profilePic ?? "",
            onChange: () async {
              final XFile? pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                account!.profilePic = pickedFile!.path;
              });
            }),
        const SizedBox(height: 40),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isEdition)
                  ReservationToggler(
                      isResAccepted: account!.isEnabled!,
                      onChange: (value) {
                        setState(() {
                          account!.isEnabled = value;
                        });
                      }),
                const Text("  Payment Type *", style: TextStyle(fontSize: 18)),
                RadioListTile<String>(
                    value: "cash",
                    secondary: const Icon(Icons.monetization_on, size: 30),
                    title: const Text("Cash Only"),
                    groupValue: account!.paymentType,
                    onChanged: (String? value) {
                      if (value!.compareTo(account!.paymentType!) != 0) {
                        setState(() {
                          account!.paymentType = value;
                        });
                      }
                    }),
                RadioListTile<String>(
                    value: "card",
                    secondary: const Icon(Icons.credit_card, size: 30),
                    title: const Text("Accept Credit Card"),
                    groupValue: account!.paymentType,
                    onChanged: (String? value) {
                      if (value!.compareTo(account!.paymentType!) != 0) {
                        setState(() {
                          account!.paymentType = value;
                        });
                      }
                    }),
                AppTextFormField(
                    initialValue: (account!.budget ?? "").toString(),
                    onSaved: (String value) =>
                        account!.budget = double.parse(value),
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please fill budget";
                      }
                    },
                    lblText: "Budget *",
                    icon: Icons.currency_yen_rounded),
                workingHoursDate(context, account!.openingTime!,
                    account!.closingTime!, true),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: CheckboxListTile(
                        title: const Text(
                          "if lunch and dinner time are seperated",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: isLunDin,
                        onChanged: (value) {
                          setState(() {
                            isLunDin = value!;
                          });
                        })),
                Visibility(
                  visible: isLunDin,
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  child: workingHoursDate(context, account!.businessHours!,
                      account!.closingTime!, false),
                ),
                const Text("Closing days (Optional)",
                    style: TextStyle(fontSize: 18)),
                Wrap(
                  children: daysValues.keys
                      .map((ClDays day) => CheckboxListTile(
                          value: daysValues[day],
                          title: Text(day.name),
                          onChanged: (value) {
                            if (value!) {
                              account!.closingDays!.add(day);
                              daysValues[day] = true;
                            } else {
                              account!.closingDays!.remove(day);
                              daysValues[day] = false;
                            }
                            setState(() {});
                          }))
                      .toList(),
                ),
                if (!widget.isEdition)
                  const Text("Count of Tables",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                if (!widget.isEdition)
                  Consumer<TableProvider>(
                    builder: (context, tableProvider, _) {
                      tableTypes = tableProvider.tableTypes;
                      return Column(
                          children: List.generate(
                        tableTypes.length,
                        (index) => TablesListTile(
                            tableTypes: tableProvider.tableTypes, index: index),
                      ));
                    },
                  ),
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
                      selectMultiImages();
                    },
                    title: const Text("Upload Restaurant Images"),
                    textColor: Theme.of(context).primaryColor,
                    iconColor: Theme.of(context).primaryColor,
                    trailing: const Icon(Icons.add_photo_alternate),
                  ),
                ),
                Wrap(
                    children: account!.restaurantImages!.map(
                  (imageone) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      height: 70,
                      width: 70,
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
                        File(imageone.path),
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ).toList()),
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
                    title: const Text("Upload Menu Picture"),
                    textColor: Theme.of(context).primaryColor,
                    iconColor: Theme.of(context).primaryColor,
                    trailing: const Icon(Icons.add_photo_alternate),
                  ),
                ),
                if (account!.menuePic!.isNotEmpty)
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
                      File(account!.menuePic!),
                      fit: BoxFit.fill,
                    ),
                  ),
                AppTextFormField(
                    initialValue: account!.description ?? "",
                    maxLines: 5,
                    onSaved: (String value) => account!.description = value,
                    onValidate: (String value) {},
                    lblText: "Restaurant Description",
                    icon: Icons.description),
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
                          child: Text(widget.isEdition ? "EDIT" : "SAVE",
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
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

  Row workingHoursDate(BuildContext context, DateTime openingTime,
      DateTime closingTime, bool isRequired) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: AppTextFormField(
              initialValue:
                  "${openingTime.hour > 9 ? openingTime.hour : "0${openingTime.hour}"}:${openingTime.minute > 9 ? openingTime.minute : "0${openingTime.minute}"}",
              onSaved: (String value) {
                int hour = int.parse(value.split(':')[0]);
                int min = int.parse(value.split(':')[1]);
                openingTime = DateTime(0, 0, 0, hour, min);
              },
              onValidate: (String value) {
                if (isRequired && value.isEmpty) {
                  return "Fill opening time like hh:mm";
                }
              },
              lblText: "Open *",
              icon: Icons.access_time_filled),
        ),
        const Text("To", style: TextStyle(fontSize: 15)),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: AppTextFormField(
              initialValue:
                  "${closingTime.hour > 9 ? closingTime.hour : "0${closingTime.hour}"}:${closingTime.minute > 9 ? closingTime.minute : "0${closingTime.minute}"}",
              onSaved: (String value) {
                int hour = int.parse(value.split(':')[0]);
                int min = int.parse(value.split(':')[1]);
                closingTime = DateTime(0, 0, 0, hour, min);
              },
              onValidate: (String value) {
                if (value.isEmpty) {
                  return "Fill closing time like hh:mm";
                }
              },
              lblText: "Close *",
              icon: Icons.access_time_filled),
        ),
      ],
    );
  }

  Padding titleText() {
    return const Padding(
      padding: EdgeInsets.only(top: 22.0),
      child: Text(
        "Account Information",
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      account!.menuePic = pickedFile!.path;
    });
  }

  void selectMultiImages() async {
    account!.restaurantImages = [];
    final List<XFile>? pickedFile =
        await picker.pickMultiImage(imageQuality: 90);
    if (pickedFile!.isNotEmpty) {
      setState(() {
        account!.restaurantImages!.addAll(pickedFile);
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   positionStream?.cancel();
  // }

  // void listenToLocationChanges() {
  //   LocationSettings locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high, distanceFilter: 100);

  //   positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position? position) {
  //     if (position != null) {
  //       setState(() {
  //         currentPosition = position;
  //       });
  //     }
  //   });
  // }
}

class ReservationToggler extends StatelessWidget {
  const ReservationToggler(
      {Key? key, required this.isResAccepted, required this.onChange})
      : super(key: key);

  final bool isResAccepted;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(5)),
      child: SwitchListTile(
          value: isResAccepted,
          title: const Text(
            "Accept Reservation ?",
            style: TextStyle(fontSize: 16),
          ),
          subtitle: const Text(
            "setting of reservation acceptance",
            style: TextStyle(fontSize: 15),
          ),
          onChanged: (value) {
            onChange(value);
          }),
    );
  }
}
