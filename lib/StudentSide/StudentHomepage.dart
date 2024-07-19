import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:BlueFace/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/FaceAuth/FaceAuthentication/auth.dart';
import '../Services/FaceAuth/FaceAuthentication/size.dart';
import '../Services/FaceAuth/FaceRegister/RegisterFaceView.dart';



class StudentLoggedIn extends StatefulWidget {
  final StudentLogin student;
  const StudentLoggedIn({Key? key, required this.student}) : super(key: key);
  @override
  _StudentLoggedInState createState() => _StudentLoggedInState();
}

class _StudentLoggedInState extends State<StudentLoggedIn> {

  bool hasScannedFace = false;

  @override
  void initState() {
    ScreenSizeUtil.context = context;
    super.initState();
    // Check if user has already scanned their face
    checkFaceScanStatus();
  }

  Future<void> checkFaceScanStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool scanned = prefs.containsKey('face_scanned');
    setState(() {
      hasScannedFace = scanned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello ${widget.student.name} !',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9A6BFF),
      ),
      body: Container(
        decoration: BoxDecoration(
         color: Color(0xFFFFFFFF)
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: hasScannedFace
                      ? null // Disable button if face has been scanned
                      : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterFaceView(),
                      ),
                    );
                  },
                  child: Text('Register'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      hasScannedFace ? Colors.grey : Color(0xFF9A6BFF),
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    minimumSize: WidgetStateProperty.all(Size(200, 50)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AuthenticateFaceView(student: widget.student),
                      ),
                    );
                    // Add give attendance functionality here
                  },
                  child: Text('Give Attendance'),
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all(Color(0xFF9A6BFF)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    minimumSize: WidgetStateProperty.all(Size(200, 50)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
