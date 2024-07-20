
import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../Services/services.dart';


class FacultyLoggedIn extends StatefulWidget {
  final FacultyLogin faculty;

  const FacultyLoggedIn({Key? key, required this.faculty}) : super(key: key);

  @override
  _FacultyLoggedInState createState() => _FacultyLoggedInState();
}

class _FacultyLoggedInState extends State<FacultyLoggedIn> {
  var service = new Services();
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
        title: Text('Hello ${widget.faculty.Faculty_name} !!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container (
          decoration: BoxDecoration(
            color: background,
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedBranch,
              onChanged: (newValue) {
                setState(() {
                  selectedBranch = newValue;
                });
              },
              items: <String>['ECS','EXTC','CE','IT','AIDS','AIML','IOT','MECHANICAL']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Branch'),
            ),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              onChanged: (newValue) {
                setState(() {
                  selectedSemester = newValue;
                });
              },
              items: <String>['1','2','3','4','5','6']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Semester'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDivision,
              onChanged: (newValue) {
                setState(() {
                  selectedDivision = newValue;
                });
              },
              items: <String>['A','B','C','D','E','F','G','H']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Divison'),
            ),
            DropdownButtonFormField<String>(
              value: selectedBatch,
              onChanged: (newValue) {
                setState(() {
                  selectedBatch = newValue;
                });
              },
              items: <String>['1','2','3','ALL']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Batch'),
            ),

            DropdownButtonFormField<String>(
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
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                hintText: 'Enter date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAdvertising ? stopAdvertising : startAdvertising,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAdvertising ? Colors.red : Colors.blue,
              ),
              child: Text(isAdvertising ? 'Stop Attendance' : 'Take Attendance'),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //
            //     );
            //   },
            //   child: Text('Student List'),
            // ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> startAdvertising() async {
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
