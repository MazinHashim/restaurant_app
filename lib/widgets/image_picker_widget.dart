import 'dart:io';

import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  const AppImagePicker(
      {Key? key, required this.imageFile, required this.onChange})
      : super(key: key);
  final String imageFile;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChange(),
      child: Stack(
        children: [
          CircleAvatar(
              radius: 60,
              foregroundImage:
                  imageFile.isNotEmpty ? FileImage(File(imageFile)) : null,
              backgroundImage: const AssetImage("assets/img/logo.png")),
          const Positioned(
              bottom: 10,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 3)],
                    color: Color(0xFFE44141),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
