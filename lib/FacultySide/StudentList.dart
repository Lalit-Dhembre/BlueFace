import 'package:flutter/material.dart';
import '../Model.dart';
import '../Services/services.dart';
import '../Services/FaceAuth/FaceAuthentication/snackbar.dart';

class StudentList extends StatefulWidget {
  @override
  StudentListState createState() => StudentListState();
}
class StudentListState extends State<StudentList> {
  List<StudentLogin> studentsList = [];
  List<ConnectedStudent> connectedStudents = [];
  var service = Services();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    await service.fetchStudents(studentsList);
    await service.fetchConnectedStudents(connectedStudents);
    setState(() {});
  }

  void _showStatusDialog(StudentLogin student) {
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
                      student.isPresent = true;
                      updateStudentStatus(student);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Present'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      student.isPresent = false;
                      updateStudentStatus(student);
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

  void updateStudentStatus(StudentLogin student) {
    final index = connectedStudents.indexWhere((connectedStudent) => connectedStudent.PRN == student.PRN);

    if (student.isPresent && index == -1) {
      connectedStudents.add(ConnectedStudent(
        studentName: student.name,
        semester1: student.Semester,
        branch: student.Branch,
        PRN: student.PRN,
        datetime: DateTime.now(),
      ));
    } else if (!student.isPresent && index != -1) {
      connectedStudents.removeAt(index);
    }

    setState(() {});
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
                  await service.commitAttendance(studentsList, 'branch', 'semester', 'subject', formattedDateTime);
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
            bool isConnected = connectedStudents.any((connected) =>
            connected.PRN == studentsList[index].PRN &&
                connected.branch == studentsList[index].Branch &&
                connected.semester1 == studentsList[index].Semester.toString());

            studentsList[index].isPresent = isConnected;

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
