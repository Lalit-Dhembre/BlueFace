import 'package:BlueFace/FacultySide/StudentList.dart' as stud;
import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${widget.faculty.Faculty_id} !!'),
        titleTextStyle: const TextStyle(color: accent),
        backgroundColor: accentOver,
        iconTheme: const IconThemeData(color: accent), // Change AppBar color to accentOver
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 40),
          decoration: const BoxDecoration(
            color: background, // Set container color to background
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      value: selectedBranch,
                      onChanged: (newValue) {
                        setState(() {
                          selectedBranch = newValue;
                        });
                      },
                      items: <String>[
                        'ECS', 'EXTC', 'CE', 'IT', 'AIDS', 'AIML', 'IOT', 'MECHANICAL'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Branch',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
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
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
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
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Division',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
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
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Batch',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: background,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items: widget.faculty.Subjects.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: background,
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        hintText: 'Enter date',
                        labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                        hintStyle: TextStyle(color: Colors.white), // Set hint text color to white
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
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
                            dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent, // Set the background color of the Student List button
                    minimumSize: const Size(200, 50), // Set minimum width and height
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => stud.StudentList(
                          semester: selectedSemester,
                          division: selectedDivision,
                          batch: selectedBatch,
                          branch: selectedBranch,
                          faculty_id: widget.faculty.Faculty_id,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Student List',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
              ),
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

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        showSnackbar("External Storage permissions not granted :(");
        resetState();
        return;
      }
    }

    try {
      await Nearby().startAdvertising(
        widget.faculty.Faculty_id,
        strategy,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          showSnackbar(status as String);
        },
        onDisconnected: (id) {
          showSnackbar("Disconnected: $id");
        },
      );
    } catch (exception) {
      showSnackbar("Exception occurred: $exception");
      resetState();
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) {
        if (payload.bytes != null) {
          showSnackbar("Data received from $endid");
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          showSnackbar("Transfer successful from $endid");
        }
      },
    );
  }

  void stopAdvertising() {
    Nearby().stopAdvertising();
    showSnackbar("Stopped advertising");
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
}
