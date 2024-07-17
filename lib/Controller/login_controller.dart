import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spaceships/screen/homeview/home.dart'; // Firestore package

class LoginScreenController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool visibility = true;
  bool isValid = true;
  String error = "";

  void onChangeValueEmail(String value) {
    update();
  }

  void onChangeValuePassword(String value) {
    update();
  }

  void visibilityToggle() {
    visibility = !visibility;
    update();
  }

  bool validateInput() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      isValid = false;
      error = "Email and password cannot be empty.";
      update();
      return false;
    }
    isValid = true;
    update();
    return true;
  }

  void loginUser(BuildContext context) async {
    if (!validateInput()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        var userDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use UID instead of email
            .get();

        if (userDocument.exists) {
          var userData = userDocument.data();
          // Print the username
          print("Username: ${userData?['name'] ?? ''}");

          // Navigate to home page with welcome message
          Get.off(() => HomeScreen(username: userData?['name'] ?? ''));

          // Show welcome message
          Get.snackbar(
            "Welcome ${userData?['name'] ?? ''}",
            "Login successful",
            snackPosition: SnackPosition.BOTTOM,
          );

        } else {
          isValid = false;
          error = "User not found.";
          update();
        }
      }

    } catch (e) {
      isValid = false;
      error = getErrorMessage(e);
      update();
    }
  }

  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        default:
          return 'Please check your email id and password.';
      }
    } else {
      return error.toString();
    }
  }

}
