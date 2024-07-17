import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Common/Theme/app_theme_helper.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  // Use RxBool for reactive updates
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Read the saved theme preference from GetStorage
    isDarkMode.value = box.read('isDarkMode') ?? false;
    // Apply the theme based on the saved preference
    Get.changeTheme(
      isDarkMode.value ? AppTheme.dark : AppTheme.light,
    );
  }

  void toggleTheme() {
    // Toggle the theme preference
    isDarkMode.value = !isDarkMode.value;
    // Apply the new theme
    Get.changeTheme(
      isDarkMode.value ? AppTheme.dark : AppTheme.light,
    );
    // Save the new theme preference to GetStorage
    box.write('isDarkMode', isDarkMode.value);
    // Update the UI if necessary

    update();
  }
}
