import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';
import '../Model.dart';
import '../Services/services.dart';
import '../Services/FaceAuth/FaceAuthentication/snackbar.dart';

class StudentList extends StatefulWidget {
  final String? semester;
  final String? division;
  final String? batch;
  final String? branch;
  final String? faculty_id;

  const StudentList({
    super.key,
    this.semester,
    this.division,
    this.batch,
    this.branch,
    this.faculty_id,
  });

  @override
  StudentListState createState() => StudentListState();
}

class StudentListState extends State<StudentList> {
  List<StudentsLists> studentsList = [];
  var service = Services();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    await service.studentslist(
      studentsList,
      widget.semester,
      widget.branch,
      widget.batch,
      widget.division,
      widget.faculty_id,
    );
    setState(() {});
  }

  void _showStatusDialog(StudentsLists student) {
    showDialog(
      context: CustomSnackBar.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mark Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${student.name}"),
              Text("PRN: ${student.PRN}"),
              SizedBox(height: 10),
              Text("Select Status:"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        student.isPresent = true;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                    ),
                    child: Text('Present'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        student.isPresent = false;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Absent'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCommitDialog() async {
    DateTime now = DateTime.now();
    String formattedDateTime = '${now.year}-${now.month}-${now.day}';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Commit Attendance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to commit attendance?"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Commit attendance logic here
                      await service.commitAttendance(
                        studentsList.cast<StudentLogin>(),
                        widget.branch ?? '', // Provide a default value
                        widget.semester ?? '', // Provide a default value
                        'subject',
                        formattedDateTime,
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Commit'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student List',
          style: TextStyle(color: Colors.white), // Text color white
        ),
        backgroundColor: background,
        foregroundColor: Colors.white, // Ensure text color is white
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background,
        ),
        child: ListView.builder(
          itemCount: studentsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: accentOver, // Background color for each student box
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${studentsList[index].name ?? 'Unknown'}",
                          style: TextStyle(color: Colors.white), // Text color white
                        ),
                        Text(
                          "PRN: ${studentsList[index].PRN ?? 'Unknown'}",
                          style: TextStyle(color: Colors.white), // Text color white
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        studentsList[index].isPresent =
                        !studentsList[index].isPresent; // Toggle status
                      });
                    },
                    child: Chip(
                      backgroundColor: studentsList[index].isPresent ? Colors.green : Colors.red,
                      label: Text(
                        studentsList[index].isPresent ? 'Present' : 'Absent',
                        style: TextStyle(color: Colors.white), // Text color white
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCommitDialog,
        child: Icon(Icons.check),
      ),
    );
  }
}