import 'dart:ui';

import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/size.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.05.sw),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(0.02.sh),
        ),
        child: Padding(
          padding: EdgeInsets.all(0.03.sw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.03.sw),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 0.025.sh,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 0.03.sh,
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.arrow_circle_right,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}