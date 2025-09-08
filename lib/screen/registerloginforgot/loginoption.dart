import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:spaceships/Common/Constants/color_helper.dart';
import 'package:spaceships/Common/Constants/string_helper.dart';
import 'package:spaceships/Controller/login_controller.dart';
import 'package:spaceships/screen/registerloginforgot/Forgotpasswordscreen.dart';


import '../../Controller/login_option_controller.dart';
import 'registerscreen.dart';

class LoginOptionScreen extends GetView<LoginOptionController> {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      4,
                          (index) => Container(
                        height: height * 0.20,
                        width: width * 0.44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage(controller.images[index]),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Launch',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 27,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: ' Bhoome',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorCodes.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      GetBuilder<LoginScreenController>(
                        builder: (controller) {
                          return AnimatedOpacity(
                            duration: const Duration(
                                seconds: 1), // Adjust the duration as needed
                            opacity: controller.isValid == true
                                ? 0.0
                                : 1.0, // Set opacity based on validation result
                            child: controller.isValid == true
                                ? const SizedBox() // Return an empty SizedBox if validation is successful
                                : Container(
                              width: width * 1,
                              decoration: BoxDecoration(
                                color: ColorCodes.teal,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20),
                                child: Center(
                                  child: Text(
                                    controller.error,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      GetBuilder<LoginScreenController>(
                        builder: (controller) {
                          return TextFormField(
                            onChanged: (value) =>
                                controller.onChangeValueEmail(value),
                            controller: controller.emailController,
                            decoration: InputDecoration(
                                fillColor:
                                Theme.of(context).colorScheme.onPrimary,
                                filled: true,
                                prefixIcon:
                                controller.emailController.text.isEmpty
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/MailIcon.png",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      height: 20,
                                    ),
                                  ],
                                )
                                    : null,
                                suffixIcon:
                                controller.emailController.text.isNotEmpty
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/MailIcon.png",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      height: 20,
                                    ),
                                  ],
                                )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: GradientOutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      ColorCodes.green,
                                      ColorCodes.teal
                                    ]),
                                    width: 2),
                                hintText: StringRes.email),
                          );
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      GetBuilder<LoginScreenController>(
                        builder: (controller) {
                          return TextFormField(
                            obscureText: controller.visibility,
                            controller: controller.passwordController,
                            onChanged: (value) =>
                                controller.onChangeValuePassword(value),
                            decoration: InputDecoration(
                                fillColor:
                                Theme.of(context).colorScheme.onPrimary,
                                filled: true,
                                prefixIcon:
                                controller.passwordController.text.isEmpty
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/LockIcon.png",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      height: 22,
                                    ),
                                  ],
                                )
                                    : null,
                                suffixIcon:
                                controller.passwordController.text.isNotEmpty
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/LockIcon.png",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      height: 22,
                                    ),
                                  ],
                                )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: GradientOutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      ColorCodes.green,
                                      ColorCodes.teal
                                    ]),
                                    width: 2),
                                hintText: StringRes.password),
                          );
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: [
                          GestureDetector(onTap: () {
                            // Navigate to Forgot Password screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Forgotpasswordscreen()),
                            );
                          },
                            child: Container(
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                    color: ColorCodes.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),

                              ),
                            ),
                          ),
                          const Spacer(),
                          GetBuilder<LoginScreenController>(
                            builder: (controller) {
                              return GestureDetector(
                                onTap: () => controller.visibilityToggle(),
                                child: controller.visibility == true
                                    ? const Text(
                                  "Show password",
                                  style: TextStyle(
                                      color: ColorCodes.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )
                                    : const Text(
                                  "hide password",
                                  style: TextStyle(
                                      color: ColorCodes.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                     const SizedBox(height: 25,),
                      GetBuilder<LoginScreenController>(builder: (controller) {
                        return controller.emailController.text.isEmpty ||
                            controller.passwordController.text.isEmpty
                            ? Container(
                          height: 55,
                        )
                            : Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                              onPressed: () {
                                if (controller.validateInput()) {
                                  // Proceed with login
                                  controller.loginUser(context);
                                }

                              },
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStateProperty.all<Color>(
                                    ColorCodes.green),
                                overlayColor:
                                WidgetStateProperty.all<Color>(
                                    ColorCodes.green),
                                shadowColor:
                                WidgetStateProperty.all<Color>(
                                    ColorCodes.green),
                                minimumSize: WidgetStateProperty.all(
                                    const Size(double.infinity, 55)),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: ColorCodes.white, fontSize: 16),
                              )),
                        );
                      }),

                    ],
                  ),
                ),

            const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: width * 0.38,
                      color: ColorCodes.grey.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorCodes.grey.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: width * 0.38,
                      color: ColorCodes.grey.withOpacity(0.3),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account? ",
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorCodes.teal),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 100,),
              ],
            ),

          ),

        ),

      ),
    );
  }
}
