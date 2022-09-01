import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resturant_app/models/address.dart';
import 'package:resturant_app/providers/account_provider.dart';

class CMap extends StatefulWidget {
  const CMap({Key? key, required this.address}) : super(key: key);

  final Address address;
  @override
  State<CMap> createState() => _CMapState();
}

class _CMapState extends State<CMap> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    // AccountProvider accProvider = Provider.of<AccountProvider>(context);
    // address = accProvider.findAddressById(widget.addressId);
    return Scaffold(
        appBar: AppBar(title: const Text("Map")),
        body: Stack(
          children: [
            Hero(
              tag: "mapo",
              child: GoogleMap(
                  onTap: (LatLng cord) {
                    setState(() {
                      widget.address.latitude = cord.latitude;
                      widget.address.longitude = cord.longitude;
                    });
                  },
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                        markerId: const MarkerId("current"),
                        position: LatLng(widget.address.latitude!,
                            widget.address.longitude!))
                  },
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.address.latitude!, widget.address.longitude!),
                    zoom: 20,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  }),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Confirm location"),
                  ),
                )),
          ],
        ));
  }
}
