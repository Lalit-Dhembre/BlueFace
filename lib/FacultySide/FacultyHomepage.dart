import 'package:BlueFace/FacultySide/StudentList.dart' as stud;
import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Services/services.dart';

class FacultyLoggedIn extends StatefulWidget {
  final FacultyLogin faculty;

  const FacultyLoggedIn({Key? key, required this.faculty}) : super(key: key);

  @override
  _FacultyLoggedInState createState() => _FacultyLoggedInState();
}

class _FacultyLoggedInState extends State<FacultyLoggedIn> {
  var service = Services();
  String? selectedSemester;
  String? selectedBranch;
  String? selectedSubject;
  String? selectedDivision;
  String? selectedBatch;
  DateTime? selectedDate;
  bool isTakeAttendancePressed = false;
  final Strategy strategy = Strategy.P2P_STAR;
  bool isAdvertising = false;

  TextEditingController dateController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${widget.faculty.Faculty_id} !!'),
        titleTextStyle: const TextStyle(color: accent),
        backgroundColor: accentOver,
        iconTheme: const IconThemeData(color: accent),// Change AppBar color to accentOver
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
<<<<<<< HEAD
          padding: const EdgeInsets.fromLTRB(30,80,30,30),
=======
          padding: const EdgeInsets.fromLTRB(30,50,30,40),
>>>>>>> 1de4e64cb7764d040e870dab3159947f1c533cfa
          decoration: const BoxDecoration(
            color: background, // Set container color to background
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrap Dropdowns in a Container with yellow background
              Container(
                decoration: BoxDecoration(
                  color: accentOver, // Set background color to yellow
                  borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
                  border: Border.all(color: Colors.black), // Optional: border color
                ),
                padding: const EdgeInsets.all(30), // Padding inside the container
                child: Column(

                  children: [
                    DropdownButtonFormField<String>(
                      padding: EdgeInsets.fromLTRB(0,0,0,30),

                      value: selectedBranch,

                      onChanged: (newValue) {
                        setState(() {
                          selectedBranch = newValue;
                        });
                      },
                      items: <String>[
                        'ECS',
                        'EXTC',
                        'CE',
                        'IT',
                        'AIDS',
                        'AIML',
                        'IOT',
                        'MECHANICAL'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
<<<<<<< HEAD
                            style: const TextStyle(color: Colors.white),),
=======
                          style: const TextStyle(color: Colors.white),),
>>>>>>> 1de4e64cb7764d040e870dab3159947f1c533cfa

                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Branch', labelStyle: TextStyle(color: Colors.white)),
                      dropdownColor: background,

                    ),
                    DropdownButtonFormField<String>(
                      padding: EdgeInsets.fromLTRB(0,0,0,30),
                      value: selectedSemester,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSemester = newValue;
                        });
                      },
                      items: <String>['1', '2', '3', '4', '5', '6']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
<<<<<<< HEAD
                            style: const TextStyle(color: Colors.white),),
=======
                              style: const TextStyle(color: Colors.white),),
>>>>>>> 1de4e64cb7764d040e870dab3159947f1c533cfa
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Semester',labelStyle: TextStyle(color: Colors.white)),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
                      padding: EdgeInsets.fromLTRB(0,0,0,30),
                      value: selectedDivision,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDivision = newValue;
                        });
                      },
                      items: <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                            style: const TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Division',labelStyle: TextStyle(color: Colors.white)),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
                      padding: EdgeInsets.fromLTRB(0,0,0,30),
                      value: selectedBatch,
                      onChanged: (newValue) {
                        setState(() {
                          selectedBatch = newValue;
                        });
                      },
                      items: <String>['1', '2', '3', 'ALL']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                            style: const TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Batch',labelStyle: TextStyle(color: Colors.white)),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
                      padding: EdgeInsets.fromLTRB(0,0,0,30),
                      value: selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items: widget.faculty.Subjects
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                            style: const TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Subject',labelStyle: TextStyle(color: Colors.white)),
                      dropdownColor: background,
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        hintText: 'Enter date',
                        labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
                        hintStyle: const TextStyle(color: Colors.white), // Set hint text color to white
                        prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2025),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                            dateController.text =
                                DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
                    ),
                  ],

                ),

              ),

              const SizedBox(height: 20),
              Center( // Center the button
                child: ElevatedButton(
                  onPressed: () {
                    if (!isAdvertising) {
                      // Button pressed and advertising is not active
                      setState(() {
                        isAdvertising = true;
                      });
                      startAdvertising();
                    } else {
                      // Button pressed and advertising is active
                      setState(() {
                        isAdvertising = false;
                      });
                      stopAdvertising();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdvertising ? Colors.red : accent, // Change the background color based on isAdvertising
                    minimumSize: const Size(200, 50), // Set minimum width and height
                  ),
                  child: Text(
                    isAdvertising ? 'Stop Attendance' : 'Take Attendance', // Change text based on isAdvertising
                    style: const TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
<<<<<<< HEAD
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent, // Set the background color of the Student List button
                    minimumSize: const Size(200, 50), // Set minimum width and height
                  ),
                  onPressed: () {  },
                  child: const Text(
                    'Student List',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
              ),
=======
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent, // Set the background color of the Student List button
                  minimumSize: const Size(200, 50), // Set minimum width and height
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>stud.StudentList()),
                  );
                },
                child: const Text(
                  'Student List',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
              ),
>>>>>>> 1de4e64cb7764d040e870dab3159947f1c533cfa
            ],
          ),
        ),
    ),
    );
  }

  Future<void> startAdvertising() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      showSnackbar("Nearby Connections is not supported on this platform.");
      resetState();
      return;
    }

    setState(() {
      isTakeAttendancePressed = true;
    });

    if (!await Nearby().askLocationPermission()) {
      showSnackbar("Location permissions not granted :(");
      resetState();
      return;
    }

    if (!await Nearby().enableLocationServices()) {
      showSnackbar("Enabling Location Service Failed :(");
      resetState();
      return;
    }

    await Permission.nearbyWifiDevices.request();
    Nearby().askBluetoothPermission();

    while (!await Permission.bluetooth.isGranted ||
        !await Permission.bluetoothAdvertise.isGranted ||
        !await Permission.bluetoothConnect.isGranted ||
        !await Permission.bluetoothScan.isGranted) {
      [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
    }

    try {
      bool advertisingStarted = await Nearby().startAdvertising(
        "SIES ${selectedSemester} ${selectedBranch}",
        strategy,
        onConnectionInitiated: (id, info) {
          onConnectionInit(id, info);
        },
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            showSnackbar("Connection established!");
          } else {
            showSnackbar("Connection failed!");
          }
        },
        onDisconnected: (id) {
          showSnackbar("Disconnected");
        },
      );
      if (advertisingStarted) {
        setState(() {
          isAdvertising = true;
        });
      } else {
        resetState();
        showSnackbar("Advertising failed to start.");
      }
    } catch (e) {
      print("Error during advertising: $e");
      resetState();
      showSnackbar("Error: $e");
    }
  }

  Future<void> stopAdvertising() async {
    try {
      await Nearby().stopAdvertising();
      showSnackbar("Stopped Advertising");
      setState(() {
        isAdvertising = false;
      });
    } catch (e) {
      showSnackbar("Error stopping advertising: $e");
    } finally {
      setState(() {
        isTakeAttendancePressed = false;
      });
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    Nearby().acceptConnection(id, onPayLoadRecieved: (endid, payload) {
      if (payload.bytes != null) {
        showSnackbar("Payload received from ${info.endpointName}");
      }
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void resetState() {
    setState(() {
      isTakeAttendancePressed = false;
      isAdvertising = false;
    });
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    super.dispose();
  }
}

class FacultyLoggedInWeb extends StatelessWidget {
  final FacultyLogin faculty;

  const FacultyLoggedInWeb({Key? key, required this.faculty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${faculty.Faculty_id} !!'),
      ),
      body: Center(
        child: Text('Nearby Connections not supported on web'),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueFace Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final FacultyLogin faculty = FacultyLogin(Faculty_id: '123', Subjects: ['Math', 'Science']);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return FacultyLoggedInWeb(faculty: faculty);
    } else {
      return FacultyLoggedIn(faculty: faculty);
    }
  }
}