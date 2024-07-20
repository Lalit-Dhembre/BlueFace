import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:BlueFace/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/FaceAuth/FaceAuthentication/auth.dart';
import '../Services/FaceAuth/FaceAuthentication/size.dart';
import '../Services/FaceAuth/FaceRegister/RegisterFaceView.dart';

// Define a constant for the background color
const Color background = Color(0xFFE6DCFF); // Replace with your desired color

class StudentLoggedIn extends StatefulWidget {
  final StudentLogin student;

  const StudentLoggedIn({Key? key, required this.student}) : super(key: key);

  @override
  _StudentLoggedInState createState() => _StudentLoggedInState();
}

class _StudentLoggedInState extends State<StudentLoggedIn> {
  bool hasScannedFace = false;
  String? selectedOption; // Variable to store the selected option

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
          style: TextStyle(color: Colors.white), // Ensure text is readable
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background, // Use the constant background color
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
                    backgroundColor: MaterialStateProperty.all(
                      hasScannedFace ? Colors.grey : Color(0xFF9A6BFF),
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    shape: MaterialStateProperty.all(
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
                    backgroundColor: MaterialStateProperty.all(Color(0xFF9A6BFF)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedOption,
                  hint: Text('Select an option'),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'option1',
                      child: Text('Option 1'),
                    ),
                    DropdownMenuItem(
                      value: 'option2',
                      child: Text('Option 2'),
                    ),
                    DropdownMenuItem(
                      value: 'option3',
                      child: Text('Option 3'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}