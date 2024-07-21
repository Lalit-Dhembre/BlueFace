// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:BlueFace/Services/services.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailsView extends StatefulWidget {
  var service = new Services();
  final String Subject_id;
  final StudentLogin student;
  UserDetailsView({super.key, required this.student, required this.Subject_id});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  int flag = 0;
  final Strategy strategy = Strategy.P2P_STAR;
  List<String> connectedStudents = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Nearby().stopDiscovery();
        setState(() {
          flag = 0;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student HomePage", style: TextStyle(color: Colors.white)),
          backgroundColor: background,
          actions: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () async {
                  await Nearby().stopDiscovery();
                  Get.offNamed('/login');
                },
                child: const Icon(Icons.logout_sharp, color: Colors.deepPurple),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (flag == 0)
                GestureDetector(
                  onTap: startDiscovery,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(72),
                          ),
                          child: const Icon(Icons.bluetooth, size: 84, color: Colors.white),
                        ),
                        const Text(
                          "Tap to mark attendance",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              else if (flag == 1)
                const CircularProgressIndicator()
              else if (flag == 2)
                  Column(
                    children: [
                      const Text("Attendance recorded!"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            flag = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: accent,
                          minimumSize: const Size(100, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text("Back"),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void startDiscovery() async {
    if (!await Nearby().askLocationPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions not granted :(")),
      );
      return;
    }

    if (!await Nearby().enableLocationServices()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enabling Location Service Failed :(")),
      );
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

    setState(() {
      flag = 1;
    });

    try {
      bool discoveryStarted = await Nearby().startDiscovery(
        "Student",
        strategy,
        onEndpointFound: (id, name, serviceId) async {
          print("Endpoint found: $name");
          if (name.startsWith("SIES")) {
            connectedStudents.add(name);
            await Nearby().stopDiscovery();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Attendance recorded!! :)")),
            );
            widget.service.markAttendance(widget.student);
            setState(() {
              flag = 2;
            });
          }
        },
        onEndpointLost: (id) {
          print("Lost discovered endpoint: $id");
        },
      );
      if (!discoveryStarted) {
        setState(() {
          flag = 0;
        });
        showSnackbar("Discovery failed to start.");
      }
    } catch (e) {
      print("Error during discovery: $e");
      setState(() {
        flag = 0;
      });
      showSnackbar("Error: $e");
    }
  }
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
