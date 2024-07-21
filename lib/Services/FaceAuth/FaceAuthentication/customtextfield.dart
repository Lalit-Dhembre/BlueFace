
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/size.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final GlobalKey formFieldKey;
  final String validatorText;

  const CustomTextField({
    Key? key,
    required this.formFieldKey,
    required this.controller,
    required this.hintText,
    required this.validatorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.055.sw, vertical: 0.02.sh),
      child: TextFormField(
          key: formFieldKey,
          controller: controller,
          cursorColor: accent,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
            color: Colors.white,)
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Name cannot be empty";
            } else {
              return null;
            }
          }),
    );
  }
}
