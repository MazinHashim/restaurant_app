import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/homepage.dart';
import 'package:resturant_app/models/account.dart';
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
  String? errMsg;
  late AuthProvider authProvider;
  late AccountProvider accProvider;
  late List<TableSeats> tableTypes = [];
  late Account? account = Account.initial();

  final ImagePicker picker = ImagePicker();

  void submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });

      if (!widget.isEdition) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _determinePosition().then((postion) {
          currentPosition = postion;
        }).then((_) {
          authProvider.getSesstionToken().then((user) {
            if (currentPosition != null) {
              account!.latitude = currentPosition!.latitude;
              account!.longitude = currentPosition!.longitude;
              account!.userId = user.id;
              accProvider.addRestaurantAccount(account!);
              prefs.remove("next_step").then((_) {
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              });
            }
          });
        }).catchError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Make sure your device location is enabled')));
        }).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        _determinePosition().then((position) {
          currentPosition = position;
        }).then((_) {
          if (currentPosition != null) {
            account!.latitude = currentPosition!.latitude;
            account!.longitude = currentPosition!.longitude;
          }
          print(account!.latitude);
          print(account!.longitude);
          accProvider.updateRestaurantAccount(account!);
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Account Data...')));
          setState(() {
            isLoading = false;
          });
        });
      }
      form.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    tableTypes = [];
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
    } else if (currentPosition != null) {
      account!.latitude = currentPosition!.latitude;
      account!.longitude = currentPosition!.longitude;
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(5)),
          child: (!widget.isEdition)
              ? const Text(
                  "Make sure you are at the resturant and your device location is enabled",
                  style: TextStyle(fontSize: 17, color: Colors.white))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latitude: ${account!.latitude!.toStringAsFixed(5)}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                    Text("Longitude: ${account!.longitude!.toStringAsFixed(5)}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
        ),
        const SizedBox(height: 20),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!widget.isEdition)
                  ReservationToggler(
                      isResAccepted: account!.isEnabled!,
                      onChange: (value) {
                        setState(() {
                          account!.isEnabled = value;
                        });
                      }),
                AppTextFormField(
                    initialValue: account!.paymentType ?? "",
                    onSaved: (String value) => account!.paymentType = value,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return "Please fill paymant type";
                      }
                    },
                    lblText: "Payment Type *",
                    icon: Icons.payment),
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
                    icon: Icons.attach_money_sharp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: AppTextFormField(
                          initialValue:
                              "${account!.openingTime!.hour}:${account!.openingTime!.minute}",
                          onSaved: (String value) {
                            int hour = int.parse(value.split(':')[0]);
                            int min = int.parse(value.split(':')[1]);
                            account!.openingTime = DateTime(0, 0, 0, hour, min);
                          },
                          onValidate: (String value) {
                            if (value.isEmpty) {
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
                              "${account!.closingTime!.hour}:${account!.closingTime!.minute}",
                          onSaved: (String value) {
                            int hour = int.parse(value.split(':')[0]);
                            int min = int.parse(value.split(':')[1]);
                            account!.closingTime = DateTime(0, 0, 0, hour, min);
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

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

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
