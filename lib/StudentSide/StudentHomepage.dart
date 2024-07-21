import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:BlueFace/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/FaceAuth/FaceAuthentication/auth.dart';
import '../Services/FaceAuth/FaceAuthentication/size.dart';
import '../Services/FaceAuth/FaceRegister/RegisterFaceView.dart';

// Define a constant for the background color
const Color background = Color(0xff48426d); // Replace with your desired color

class StudentLoggedIn extends StatefulWidget {
  final StudentLogin student;

  const StudentLoggedIn({Key? key, required this.student}) : super(key: key);

  @override
  _StudentLoggedInState createState() => _StudentLoggedInState();
}

class _StudentLoggedInState extends State<StudentLoggedIn> {
  bool hasScannedFace = false;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    checkFaceScanStatus();
  }

  Future<void> checkFaceScanStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool scanned = prefs.containsKey('face_scanned');
    setState(() {
      hasScannedFace = scanned;
    });
  }

  void _giveAttendance() {
    if (selectedSubject == null || selectedSubject!.isEmpty) {
      // Show a SnackBar if no subject is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a subject.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Navigate to the attendance screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AuthenticateFaceView(
            student: widget.student,
            subject_id: selectedSubject.toString(),
          ),
        ),
      );
      // Add give attendance functionality here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello ${widget.student.name} !',
          style: TextStyle(color: accent), // Ensure text is readable
        ),
        backgroundColor: accentOver, // Make AppBar transparent
        elevation: 0,
        iconTheme: const IconThemeData(color: accent),// Remove shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
            // Adjust the radius as needed
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background, // Use the constant background color
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 35.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal margin
              decoration: BoxDecoration(
                color: accentOver, // Background color for buttons and dropdown
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(height: 25), // Increase the gap between buttons and dropdown
                  ElevatedButton(
                    onPressed: _giveAttendance, // Call the new function
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
                  SizedBox(height: 45), // Increase the gap between buttons and dropdown
                  // Check if the subjects list is empty
                  if (widget.student.Subjects.isEmpty)
                    Text(
                      'Select the subject',
                      style: TextStyle(color: Colors.red), // Style for the message
                    )
                  else
                  // Wrap the DropdownButtonFormField with a SizedBox to match button width
                    SizedBox(
                      width: 200, // Set the width to match the buttons
                      child: DropdownButtonFormField<String>(
                        value: selectedSubject,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSubject = newValue!;
                          });
                        },
                        items: widget.student.Subjects
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.white), // Text color for dropdown items
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          labelStyle: TextStyle(color: Colors.white), // Label color
                          filled: true,
                          fillColor: background, // Background color of the dropdown
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none, // Remove border
                          ),
                        ),
                        dropdownColor: background, // Background color when dropdown is open
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}