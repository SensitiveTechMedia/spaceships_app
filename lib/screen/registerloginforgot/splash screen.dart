import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/screen/homeview/home.dart';





class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      // Navigate to the login page after 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: '',)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // Define the dark blue color with the correct ARGB value
    final darkBlueColor = Color(0xFF00007F); // Example dark blue color

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: ColorUtils.primaryColor(), // Set the background color to dark blue
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: height * 0.30,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      child: Image.asset(
                        "assets/images/OnBoardingSplash.png",
                        height: 100,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -100,
                      child: Container(
                        width: 150,
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
