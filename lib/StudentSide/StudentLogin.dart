import 'package:BlueFace/Services/FaceAuth/FaceAuthentication/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BlueFace/Model.dart';
import 'package:BlueFace/Services/services.dart';

class StudentLoginPage extends StatefulWidget {
  StudentLoginPage({Key? key}) : super(key: key);

  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  var service = Services();
  bool _showPassword = false;
  bool _isLoggedIn = false; // Track login state

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    String password = prefs.getString('password') ?? '';

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _email.text = email;
        _password.text = password;
        _isLoggedIn = true; // Set login state to true
      });
    }
  }

  Future<void> _saveLoginData(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  void _clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('password', '');
  }

  void _login() {
    if (_password.text.isEmpty || _email.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email and password are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xFF9A6BFF),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      service.loginStudent(context, _email.text, _password.text).then((success) {
        if (success) {
          _saveLoginData(_email.text, _password.text); // Save login data
          setState(() {
            _isLoggedIn = true; // Update login state
          });
        } else {
          Fluttertoast.showToast(
            msg: "Login failed. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF9A6BFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: background,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9A6BFF),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to Continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9A6BFF),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: accentOver,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please enter Email', style: TextStyle(color: Colors.white)),
                          TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              fillColor: Colors.white, // Set background color to white
                              filled: true, // Enable filling
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text('Please enter Password', style: TextStyle(color: Colors.white)),
                          TextFormField(
                            controller: _password,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              fillColor: Colors.white, // Set background color to white
                              filled: true, // Enable filling
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _login,
                            child: Text('LOGIN'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFF9A6BFF)),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  if (_isLoggedIn) // Show welcome message if logged in
                    Text(
                      'Welcome, ${_email.text}!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9A6BFF),
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