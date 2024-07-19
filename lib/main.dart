import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'FacultySide/FacultyLoginPage.dart';
import 'StudentSide/StudentLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9A6BFF)),
        // Adjust other theme properties as needed
      ),
      home: const PersonaSelectionScreen(),
    );
  }
}

class PersonaSelectionScreen extends StatelessWidget {
  const PersonaSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopShape(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Who are you ?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9A6BFF), // Set the text color to purple
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      _buildPersonaGrid(context),
                    ],
                  ),
                ),
              ),
              _buildBottomShape(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopShape() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF9A6BFF).withOpacity(0.3), // Set the top shape color to purple with opacity
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
    );
  }

  Widget _buildPersonaGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildPersonaItem(context, 'Student', Icons.school),
        _buildPersonaItem(context, 'Faculty', Icons.person),
      ],
    );
  }

  Widget _buildPersonaItem(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'Student') {
          Get.to(() => StudentLoginPage()); // Navigate to the Student Login screen
        } else {
          switch (title) {
            case 'Faculty':
              Get.to(() => FacultyLoginPage()); // Navigate to the Faculty Login screen
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title selected')),
              );
          }
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF9A6BFF), // Set the button color to purple
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 50, color: Colors.white), // Set the icon color to white
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF9A6BFF)), // Set the text color to purple
          ),
        ],
      ),
    );
  }

  Widget _buildBottomShape() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF9A6BFF).withOpacity(0.3), // Set the bottom shape color to purple with opacity
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
        ),
      ),
    );
  }
}