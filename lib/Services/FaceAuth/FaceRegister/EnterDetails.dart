import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model.dart';
import '../FaceAuthentication/CustomButton.dart';
import '../FaceAuthentication/customtextfield.dart';
import '../FaceAuthentication/snackbar.dart';
import '../FaceAuthentication/themes.dart';

class EnterDetailsView extends StatefulWidget {
  final String image;
  final FaceFeatures faceFeatures;
  const EnterDetailsView({
    Key? key,
    required this.image,
    required this.faceFeatures,
  }) : super(key: key);

  @override
  State<EnterDetailsView> createState() => _EnterDetailsViewState();
}

class _EnterDetailsViewState extends State<EnterDetailsView> {
  bool isRegistering = false;
  final _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
  void _restartApp(BuildContext context) {
    // Using platform-specific code to restart the app
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (Platform.isMacOS) {
      // For macOS, we can use the following method
      exit(0); // Ensure to handle this gracefully in production
    } else {
      // For other platforms, you might need different handling
      throw UnsupportedError('Restart not supported on this platform');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Add Details"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  formFieldKey: _formFieldKey,
                  controller: _nameController,
                  hintText: "Name",
                  validatorText: "Name cannot be empty",
                ),
                CustomButton(
                  text: "Register Now",
                  onTap: () async {
                    if (_formFieldKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: accentColor,
                          ),
                        ),
                      );

                      String userId = Uuid().v1();
                      UserModel user = UserModel(
                        id: userId,
                        name: _nameController.text.trim().toUpperCase(),
                        image: widget.image,
                        registeredOn: DateTime.now().millisecondsSinceEpoch,
                        faceFeatures: widget.faceFeatures,
                      );

                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final String userJson = jsonEncode(user.toJson());

                        await prefs.setString('face_scanned', userJson);

                        Navigator.of(context).pop();
                        CustomSnackBar.successSnackBar("Registration Success!");

                        Future.delayed(const Duration(seconds: 1), () {
                          // Navigates back to the initial page (presumably the HomePage)
                          _restartApp(context);
                        });
                      } catch (e) {
                        log("Registration Error: $e");
                        Navigator.of(context).pop();
                        CustomSnackBar.errorSnackBar(
                            "Registration Failed! Try Again.");
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

