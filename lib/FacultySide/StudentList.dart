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

  const StudentList({super.key, this.semester, this.division, this.batch, this.branch, this.faculty_id});

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
    await service.studentslist(studentsList, widget.semester, widget.branch, widget.batch, widget.division, widget.faculty_id);
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
                      backgroundColor: Colors.green,
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
      context: CustomSnackBar.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Commit Attendance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to commit attendance?"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // await service.commitAttendance(studentsList, widget.branch, widget.semester, 'subject', formattedDateTime);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Commit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('Cancel'),
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
        title: Text('Student List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white54, Colors.white70],
          ),
        ),
        child: ListView.builder(
          itemCount: studentsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("Name: ${studentsList[index].name ?? 'Unknown'}"),
              subtitle: Text("PRN: ${studentsList[index].PRN ?? 'Unknown'}"),
              trailing: studentsList[index].isPresent
                  ? Chip(
                backgroundColor: Colors.green,
                label: Text('Present'),
              )
                  : Chip(
                backgroundColor: Colors.red,
                label: Text('Absent'),
              ),
              onLongPress: () {
                _showStatusDialog(studentsList[index]);
              },
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
