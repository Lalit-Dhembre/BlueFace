import 'dart:convert';
import 'package:BlueFace/Model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../FacultySide/FacultyHomepage.dart';
import '../StudentSide/StudentHomepage.dart';




class Services {
  final String url1 = "http://192.168.150.38:4000";

  Future<bool> loginStudent(BuildContext context, String email, String password) async {
    var url = Uri.parse(url1 + '/userss/loginstudent'); // Replace with your server URL
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email.toString().trim(),
          "password": password.toString().trim(),
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Response data: $responseData'); // Add this line to debug response data
        if (responseData['success'] == true) {
          var studentData = responseData['data'];
          StudentLogin student = StudentLogin.fromJson(studentData);
          print('Student data: $studentData'); // Add this line to debug student data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentLoggedIn(student: student),
            ),
          );
          return true;
        } else {
          Fluttertoast.showToast(
            msg: "Login failed. Please check your credentials.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Login failed. Please check your credentials.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error during login: $e');
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return false;
  }


  Future<bool> loginFaculty(BuildContext context, String email, String password) async {
    var url = Uri.parse(url1 + '/userss/login');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email.toString().trim(),
          "password": password.toString().trim(),
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          var facultyData = responseData['data'];
          print("Connected");

          // Print the received data to debug
          print(facultyData);

          FacultyLogin faculty = FacultyLogin.fromJson(facultyData);
          print(faculty.Faculty_id);
          print(faculty.Subjects);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FacultyLoggedIn(faculty: faculty)),
          );
          return true;
        } else {
          _showToast("Login failed. Please check your credentials.");
        }
      } else {
        _showToast("Login failed. Please check your credentials.");
      }
    } catch (e) {
      print('Error during login: $e');
      _showToast("An error occurred. Please try again.");
    }
    return false;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> markAttendance(StudentLogin student, String semester_id) async {
    String url = url1+'/userss/takeAttendance'; // Replace with your server URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'division': student.Division,
          'semester': student.Semester,
          'branch': student.Branch,
          'PRN': student.PRN,
          'Batch': student.Batch,
          'Subject_id': semester_id
        }),
      );

      if (response.statusCode == 200) {
        print('Attendance recorded successfully');
      } else {
        print('Failed to record attendance');
        // Optionally handle failure
      }
    } catch (e) {
      print('Error recording attendance: $e');
      // Handle error
    }
  }
  Future<void> studentslist(List<StudentsLists> studentsList, String? semester, String? branch, String? batch, String? division, String? faculty_id) async {
    String url = "$url1/userss/studentlist?semester=$semester&branch=$branch&batch=$batch&division=$division&faculty_id=$faculty_id";
    print('Request URL: $url'); // Log the URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          studentsList.clear();
          for (var student in data['students']) {
            studentsList.add(StudentsLists(
              PRN: student['PRN'],
              name: student['Name'],
              isPresent: student['isPresent'],
            ));
          }
        } else {
          throw Exception('No students found');
        }
      } else {
        throw Exception('Failed to load students data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students data: $e');
      throw Exception('Failed to fetch students data');
    }
  }



  Future<void> fetchStudents(List<StudentLogin> studentsList) async {
    try {
      final res = await http.get(Uri.parse('$url1/userss/students'));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data['success']) {
          studentsList.clear();
          for (var student in data['data']) {
            studentsList.add(StudentLogin(
              name: student['Name'],
              PRN: student['PRN'],
              Semester: student['SEMESTER'],
              Branch: student['BRANCH'],
              Division: student['DIVISION'],
              Batch: student['BATCH'],
              Subjects: [],
            ));
          }
        } else {
          throw Exception('No students found');
        }
      } else {
        throw Exception('Failed to load students data, status code: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching students data: $e');
      throw Exception('Failed to fetch students data');
    }
  }


  Future<void> fetchConnectedStudents(List<ConnectedStudent> connectedStudents) async {
    connectedStudents.clear();
    try {
      final res = await http.get(Uri.parse('$url1/userss/connectattendance'));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data['status_code'] == 200) {
          List<dynamic> connectedData = data['connect_students'];
          connectedData.forEach((value) {
            connectedStudents.add(ConnectedStudent(
              studentName: value['Name'],
              semester1: value['SEMESTER'],
              branch: value['BRANCH'],
              division: value['DIVISION'],
              batch: value['BATCH'],
              PRN: value['PRN'],
              datetime: DateTime.parse(value['date']),
            ));
          });
        } else {
          throw Exception('Failed to fetch connected students data');
        }
      } else {
        throw Exception('Failed to load connected students data, status code: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching connected students data: $e');
      throw Exception('Failed to fetch connected students data');
    }
  }

  // Future<void> commitAttendance(List<StudentLogin> studentsList, String branch, String semester, String subject, String localDateTime) async {
  //   String tableName = '${branch}_${semester}_${subject}';
  //   List<Map<String, dynamic>> attendanceData = studentsList.map((student) {
  //     return {
  //       'PRN': student.PRN,
  //       'status': student.isPresent ? 'Present' : 'Absent',
  //     };
  //   }).toList();
  //
  //   try {
  //     final res = await http.post(
  //       Uri.parse('$url1/userss/attendance/commit'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'tableName': tableName,
  //         'localDateTime': localDateTime,
  //         'attendanceData': attendanceData,
  //       }),
  //     );
  //
  //     if (res.statusCode == 200) {
  //       var data = jsonDecode(res.body);
  //       if (!data['success']) {
  //         throw Exception('Failed to commit attendance data');
  //       }
  //     } else {
  //       throw Exception('Failed to commit attendance data, status code: ${res.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error committing attendance data: $e');
  //     throw Exception('Failed to commit attendance data');
  //   }
  // }
  Future<void> commitAttendance(
      String? semester,
      String? division,
      String? batch,
      String? branch,
      String? facultyId,
      List<String?> prns) async {
    try {
      final response = await http.post(
        Uri.parse(url1 + "/userss/commit"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'semester': semester,
          'division': division,
          'batch': batch,
          'branch': branch,
          'faculty_id': facultyId,
          'prns': prns,
        }),
      );

      if (response.statusCode == 200) {// Successfully committed attendance
        print('Attendance committed successfully');

      } else {// Failed to commit attendance
        print('Failed to commit attendance: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');

    }
  }
}