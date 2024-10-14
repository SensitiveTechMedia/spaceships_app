import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import '../../Common/Constants/color_helper.dart';
import '../../Common/Constants/string_helper.dart';
import '../../Common/Widgets/elevated_button.dart';
import '../../Controller/register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Create your",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: " account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorCodes.teal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to Space Ships",
                style: TextStyle(
                  color: ColorCodes.teal.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),
              GetBuilder<RegisterController>(
                builder: (controller) {
                  return TextFormField(
                    onChanged: (value) => controller.onChangeValueName(value),
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      filled: true,
                      prefixIcon: controller.nameController.text.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [ColorCodes.green, ColorCodes.teal],
                        ),
                        width: 2,
                      ),
                      hintText: "Full Name",
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<RegisterController>(
                      builder: (controller) {
                        return TextFormField(
                          onChanged: (value) => controller.onChangeValueEmail(value),
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.onPrimary,
                            filled: true,
                            prefixIcon: controller.emailController.text.isEmpty
                                ? const Icon(Icons.mail)
                                : null,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            focusedBorder: const GradientOutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              gradient: LinearGradient(
                                colors: [ColorCodes.green, ColorCodes.teal],
                              ),
                              width: 2,
                            ),
                            hintText: "Enter Email",
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.isSendOTPEnabled.value ? controller.sendOTP : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    child: controller.isSendOTPEnabled.value
                        ? const Text('Send OTP')
                        : Text('Wait ${controller.timerSeconds.value} seconds'),
                  ),
                ],
              ),



              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GetBuilder<RegisterController>(
                          builder: (controller) {
                            return TextFormField(
                              onChanged: (value) => controller.onChangeValueOTP(value),
                              controller: controller.otpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [LengthLimitingTextInputFormatter(6)],
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).colorScheme.onPrimary,
                                filled: true,
                                prefixIcon: controller.otpController.text.isEmpty
                                    ? const Icon(Icons.design_services)
                                    : null,
                                suffixIcon: ElevatedButton(
                                  onPressed: () {
                                    controller.validateOTP();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(9),
                                        topRight: Radius.circular(9), // Adjust this value as needed
                                      ),
                                    ),
                                  ),
                                  child: const Text("Verify OTP"),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: GradientOutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [ColorCodes.green, ColorCodes.teal],
                                  ),
                                  width: 2,
                                ),
                                hintText: "Enter OTP",
                              ),
                              enabled: !controller.isOTPVerified.value,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width:2),
                ],
              ),





              const SizedBox(height: 20),
              GetBuilder<RegisterController>(
                builder: (controller) {
                  return TextFormField(
                    controller: controller.passwordController,
                    onChanged: (value) => controller.onChangeValuePassword(value),
                    obscureText: !controller.visibility.value,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      filled: true,
                      prefixIcon: controller.passwordController.text.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/LockIcon.png",
                            color: Theme.of(context).colorScheme.primary,
                            height: 22,
                          ),
                        ],
                      )
                          : null,
                      suffixIcon: controller.passwordController.text.isNotEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/LockIcon.png",
                            color: Theme.of(context).colorScheme.primary,
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
                        gradient: const LinearGradient(colors: [ColorCodes.green, ColorCodes.teal]),
                        width: 2,
                      ),
                      hintText: StringRes.password,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    "Terms of service",
                    style: TextStyle(
                      color: ColorCodes.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  GetBuilder<RegisterController>(
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () => controller.visibilityToggle(),
                        child: Text(
                          controller.visibility.value ? "Hide password" : "Show password",
                          style: const TextStyle(
                            color: ColorCodes.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GetBuilder<RegisterController>(
                builder: (controller) {
                  return getElevatedButtonLarge(
                    onTap: () async {
                      await controller.saveUserData(context);
                    },
                    string: "Register",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
