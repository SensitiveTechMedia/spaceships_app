// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:spaceships/Controller/login_controller.dart';
// import 'package:spaceships/screen/registerscreen.dart';
//
// import '../../Common/Constants/color_helper.dart';
// import '../../Common/Constants/string_helper.dart';
// import '../../Controller/login_controller.dart';
//
// class LoginScreen extends GetView<LoginScreenController> {
//   LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GetBuilder<LoginScreenController>(
//                 builder: (controller) {
//                   return controller.emailController.text.isEmpty &&
//                       controller.passwordController.text.isEmpty
//                       ? Image.asset("assets/images/LoginScreenImage.png")
//                       : Padding(
//                     padding: const EdgeInsets.only(left: 15, top: 15),
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusScope.of(context).unfocus();
//                         Get.back();
//                       },
//                       child: Container(
//                         height: 130,
//                         alignment: Alignment.topLeft,
//                         child: CircleAvatar(
//                           maxRadius: 25,
//                           backgroundColor:
//                           Theme.of(context).colorScheme.onPrimary,
//                           child: Icon(
//                             Icons.arrow_back_ios_new,
//                             size: 20,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.5),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: height * 0.02,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         text: "Let’s",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontSize: 30,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: " Sign In",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: ColorCodes.teal,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     GetBuilder<LoginScreenController>(
//                       builder: (controller) {
//                         return AnimatedOpacity(
//                           duration: Duration(
//                               seconds: 1), // Adjust the duration as needed
//                           opacity: controller.isValid == true
//                               ? 0.0
//                               : 1.0, // Set opacity based on validation result
//                           child: controller.isValid == true
//                               ? SizedBox() // Return an empty SizedBox if validation is successful
//                               : Container(
//                             width: width * 1,
//                             decoration: BoxDecoration(
//                               color: ColorCodes.teal,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 20),
//                               child: Center(
//                                 child: Text(
//                                   controller.error,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     GetBuilder<LoginScreenController>(
//                       builder: (controller) {
//                         return TextFormField(
//                           onChanged: (value) =>
//                               controller.onChangeValueEmail(value),
//                           controller: controller.emailController,
//                           decoration: InputDecoration(
//                               fillColor:
//                               Theme.of(context).colorScheme.onPrimary,
//                               filled: true,
//                               prefixIcon:
//                               controller.emailController.text.isEmpty
//                                   ? Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     "assets/images/MailIcon.png",
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primary,
//                                     height: 20,
//                                   ),
//                                 ],
//                               )
//                                   : null,
//                               suffixIcon:
//                               controller.emailController.text.isNotEmpty
//                                   ? Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     "assets/images/MailIcon.png",
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primary,
//                                     height: 20,
//                                   ),
//                                 ],
//                               )
//                                   : null,
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: GradientOutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(colors: [
//                                     ColorCodes.green,
//                                     ColorCodes.teal
//                                   ]),
//                                   width: 2),
//                               hintText: StringRes.email),
//                         );
//                       },
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     GetBuilder<LoginScreenController>(
//                       builder: (controller) {
//                         return TextFormField(
//                           obscureText: controller.visibility,
//                           controller: controller.passwordController,
//                           onChanged: (value) =>
//                               controller.onChangeValuePassword(value),
//                           decoration: InputDecoration(
//                               fillColor:
//                               Theme.of(context).colorScheme.onPrimary,
//                               filled: true,
//                               prefixIcon:
//                               controller.passwordController.text.isEmpty
//                                   ? Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     "assets/images/LockIcon.png",
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primary,
//                                     height: 22,
//                                   ),
//                                 ],
//                               )
//                                   : null,
//                               suffixIcon:
//                               controller.passwordController.text.isNotEmpty
//                                   ? Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     "assets/images/LockIcon.png",
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primary,
//                                     height: 22,
//                                   ),
//                                 ],
//                               )
//                                   : null,
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: GradientOutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(colors: [
//                                     ColorCodes.green,
//                                     ColorCodes.teal
//                                   ]),
//                                   width: 2),
//                               hintText: StringRes.password),
//                         );
//                       },
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Forgot password?",
//                           style: TextStyle(
//                               color: ColorCodes.teal,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14),
//                         ),
//                         Spacer(),
//                         GetBuilder<LoginScreenController>(
//                           builder: (controller) {
//                             return GestureDetector(
//                               onTap: () => controller.visibilityToggle(),
//                               child: controller.visibility == true
//                                   ? Text(
//                                 "Show password",
//                                 style: TextStyle(
//                                     color: ColorCodes.teal,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14),
//                               )
//                                   : Text(
//                                 "hide password",
//                                 style: TextStyle(
//                                     color: ColorCodes.teal,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: height * 0.06,
//                     ),
//                     GetBuilder<LoginScreenController>(builder: (controller) {
//                       return controller.emailController.text.isEmpty ||
//                           controller.passwordController.text.isEmpty
//                           ? Container(
//                         height: 55,
//                       )
//                           : Padding(
//                         padding:
//                         const EdgeInsets.symmetric(horizontal: 15),
//                         child: ElevatedButton(
//                             onPressed: () {
//                               if (controller.validateInput()) {
//                                 // Proceed with login
//                                 controller.loginUser(context);
//                               }
//
//                             },
//                             style: ButtonStyle(
//                               backgroundColor:
//                               MaterialStateProperty.all<Color>(
//                                   ColorCodes.green),
//                               overlayColor:
//                               MaterialStateProperty.all<Color>(
//                                   ColorCodes.green),
//                               shadowColor:
//                               MaterialStateProperty.all<Color>(
//                                   ColorCodes.green),
//                               minimumSize: MaterialStateProperty.all(
//                                   Size(double.infinity, 55)),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                             ),
//                             child: Text(
//                               "Login",
//                               style: TextStyle(
//                                   color: ColorCodes.white, fontSize: 16),
//                             )),
//                       );
//                     }),
//                     SizedBox(
//                       height: height * 0.06,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 1,
//                           width: width * 0.38,
//                           color: ColorCodes.grey.withOpacity(0.3),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Text(
//                             "OR",
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: ColorCodes.grey.withOpacity(0.9),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 1,
//                           width: width * 0.38,
//                           color: ColorCodes.grey.withOpacity(0.3),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: height * 0.03,
//                     ),
//                     Row(
//                       children: [
//                         Card(
//                           elevation: 0.7,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: height * 0.03,
//                                 horizontal: width * 0.17),
//                             child: Image.asset(
//                               "assets/images/Google.png",
//                               height: 26,
//                             ),
//                           ),
//                         ),
//                         Spacer(),
//                         Card(
//                           elevation: 0.7,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: height * 0.03,
//                                 horizontal: width * 0.17),
//                             child: Image.asset(
//                               "assets/images/FaceBook.png",
//                               height: 26,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Don’t have an account? ",
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => RegisterScreen()),
//                             );
//                           },
//                           child: Text(
//                             "Register",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: ColorCodes.teal),
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: height * 0.02,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
