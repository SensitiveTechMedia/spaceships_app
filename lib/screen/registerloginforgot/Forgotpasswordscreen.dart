import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpasswordscreen extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<Forgotpasswordscreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String error = '';
  Color customTeal = Color(0xFF1F4C6B);
  double _opacity = 0.0; // Initial opacity

  @override
  void initState() {
    super.initState();
    // Set opacity to 1.0 after a short delay to trigger the fade-in animation
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: customTeal,
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 1), // Duration for fade-in animation
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                  ),
                  Text(
                    "Please enter your email below.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else {
                        email = value; // Assigning value to email
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0), // Added some space between TextFormField and ElevatedButton
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customTeal,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      child: Text('Submit', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email)
                              .then((value) => showAlertDialog(context));
                        }
                      },
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

  void showAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        // Trigger fade-out animation when OK button is pressed
        setState(() {
          _opacity = 0.0;
        });
        // Close the dialog after the fade-out animation
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Password Reset Link Sent"),
      content: Text(
          "Please check your inbox for a link to reset your password affiliated with the submitted email above."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
