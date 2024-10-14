import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:spaceships/screen/homeview/home.dart';

import 'package:uuid/uuid.dart';

class RegisterController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var otpController = TextEditingController();
  var passwordController = TextEditingController();

  var isOTPSent = false.obs;
  var isOTPVerified = false.obs;
  var visibility = false.obs;
  var timerSeconds = 30.obs;
  var isSendOTPEnabled = true.obs;
  final EmailOTP myauth = EmailOTP();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  final Uuid uuid = const Uuid();

  void onChangeValueName(String value) {
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      nameController.clear();
      Get.snackbar('Error', 'Name should only contain letters and spaces');
    }
  }
  void onChangeValueEmail(String value) {
    // Add logic to handle email change
  }

  void onChangeValueOTP(String value) {
    // Add logic to handle OTP change
  }

  void onChangeValuePassword(String value) {
    // Add logic to handle password change
  }
  Future<void> sendOTP() async {
    myauth.setConfig(
      appEmail: "phpproject13052001@gmail.com",
      appName: "Email OTP",
      userEmail: emailController.text,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );

    if (await myauth.sendOTP()) {
      isOTPSent.value = true;
      isSendOTPEnabled.value = false;
      startOTPTimer();
      Get.snackbar('Success', 'OTP has been sent');
    } else {
      Get.snackbar('Error', 'Oops, OTP send failed');
    }
  }

  void startOTPTimer() {
    timerSeconds.value = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
        isSendOTPEnabled.value = true;
      }
    });
  }

  void visibilityToggle() {
    visibility.value = !visibility.value;
    update();
  }

  Future<void> validateOTP() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    if (await myauth.verifyOTP(otp: otpController.text)) {
      isOTPVerified.value = true;
      Get.snackbar('Success', 'OTP verified. You can now enter your password');
    } else {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  Future<void> saveUserData(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        otpController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Ensure the user is authenticated
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Check if the user already exists in Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This email is already registered'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Save user data to Firestore
      await firestore.collection('users').doc(uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(username: '',)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
