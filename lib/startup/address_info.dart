import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/address.dart';
import 'package:resturant_app/providers/account_provider.dart';
import 'package:resturant_app/providers/auth_provider.dart';
import 'package:resturant_app/startup/startup_content.dart';
import 'package:resturant_app/startup/startup_screen.dart';
import 'package:resturant_app/widgets/app_text_field.dart';
import 'package:resturant_app/widgets/cmap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressInfo extends StatefulWidget {
  const AddressInfo({Key? key}) : super(key: key);

  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Position? currentPosition;
  final Completer<GoogleMapController> _controller = Completer();
  late bool isLoading;
  late AuthProvider authProvider;
  late AccountProvider accProvider;
  late Address address = Address.initial();

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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("next_step", "activate").then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: const Text('Proccessing Address Data...')));
        form.reset();
        Navigator.pushReplacementNamed(context, StartupScreen.routeName,
            arguments: StartupContent.activatedStep);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  late StreamSubscription<Position> positionStream;

  void listenToCurrentLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 200,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      setState(() {
        print(address.latitude);
        currentPosition = position;
        address.latitude = currentPosition!.latitude;
        address.longitude = currentPosition!.longitude;
        print(address.latitude);
      });
    });
    // positionStream.onDone(() {
    //   positionStream.cancel();
    // });
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _determinePosition().then((postion) {
      currentPosition = postion;
      listenToCurrentLocation();
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context);
    accProvider = Provider.of<AccountProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.is)
    if (currentPosition != null) {
      address.latitude = currentPosition!.latitude;
      address.longitude = currentPosition!.longitude;
    }

    return Center(
      child: isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(child: CircularProgressIndicator()))
          : currentPosition == null
              ? Column(
                  children: [
                    const Text('Make sure your device location is enabled'),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          _determinePosition().then((postion) {
                            currentPosition = postion;
                          }).onError((error, stackTrace) {
                            setState(() {
                              isLoading = false;
                            });
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh"),
                    )
                  ],
                )
              : Column(
                  children: [
                    titleText(),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Hero(
                            tag: "mapo",
                            child: GoogleMap(
                                mapType: MapType.normal,
                                markers: {
                                  Marker(
                                      markerId: const MarkerId("current"),
                                      position: LatLng(address.latitude!,
                                          address.longitude!))
                                },
                                cameraTargetBounds:
                                    CameraTargetBounds.unbounded,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      address.latitude!, address.longitude!),
                                  zoom: 18,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                }),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              CMap(address: address)));
                                },
                                child: const Text("Pin location")),
                          )
                        ],
                      ),
                    ),
                    Text('${address.latitude} ${address.longitude}'),
                    const SizedBox(height: 40),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Postcode",
                                  style: TextStyle(fontSize: 23),
                                )),
                            AppTextFormField(
                                initialValue:
                                    (address.postcode ?? "").toString(),
                                onSaved: (String value) {
                                  value =
                                      value.replaceFirst(RegExp(r'-'), "", 3);
                                  address.postcode = int.parse(value);
                                  print(value);
                                },
                                onValidate: (String code) {
                                  if (code.isEmpty) {
                                    return "Please fill postcode";
                                  } else if (!code.contains("-", 3)) {
                                    return "Invalid format";
                                  } else if (code.length != 8 ||
                                      !code
                                          .replaceFirst(RegExp(r'-'), "", 3)
                                          .contains(RegExp(r'[0-9]'))) {
                                    print(
                                        code.replaceFirst(RegExp(r'-'), "", 3));
                                    return "Postcode must be exactly 7 digits";
                                  }
                                },
                                lblText: "E.g. 123-4567 *",
                                icon: Icons.local_post_office),
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ward",
                                  style: TextStyle(fontSize: 23),
                                )),
                            AppTextFormField(
                                initialValue: address.ward ?? "",
                                onSaved: (String value) => address.ward = value,
                                onValidate: (String value) {
                                  if (value.isEmpty) {
                                    return "Please fill ward";
                                  }
                                },
                                keyboardType: TextInputType.text,
                                lblText: "E.g. Minato-ku *",
                                icon: Icons.home_mini),
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "District or Block",
                                  style: TextStyle(fontSize: 23),
                                )),
                            AppTextFormField(
                                initialValue: address.block ?? "",
                                onSaved: (String value) =>
                                    address.block = value,
                                onValidate: (String value) {},
                                lblText: "E.g. Roppongi 1-1-1 *",
                                keyboardType: TextInputType.url,
                                icon: Icons.border_all),
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Building name (optional)",
                                  style: TextStyle(fontSize: 23),
                                )),
                            AppTextFormField(
                                initialValue: address.buildName ?? "",
                                onSaved: (String value) =>
                                    address.buildName = value,
                                onValidate: (String value) {},
                                lblText: "E.g. Mori Tower",
                                keyboardType: TextInputType.url,
                                icon: Icons.business_outlined),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Unit number (optional)",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            AppTextFormField(
                                initialValue: address.unitNumber ?? "",
                                onSaved: (String value) =>
                                    address.unitNumber = value,
                                onValidate: (String value) {},
                                lblText: "E.g. 3B,4404",
                                keyboardType: TextInputType.url,
                                icon: Icons.numbers),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 54,
                              width: double.infinity,
                              child: !isLoading
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                      onPressed: () => submit(),
                                      child: const Text("SAVE",
                                          style: TextStyle(
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
                ),
    );
  }

  Padding titleText() {
    return const Padding(
      padding: EdgeInsets.only(top: 22.0),
      child: Text(
        "Address Informaition",
        style: TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
