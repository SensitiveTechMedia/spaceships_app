import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Common/Constants/color_helper.dart';
import '../Common/Widgets/elevated_button.dart';

class BottomNavigationBarController extends GetxController {
  bool selectedLocation = false;

  RxInt selectedIndex = 0.obs;
  RxInt selectLocationIndex = 0.obs;

  final box = GetStorage();

  void selectLocationIndexToggle(index) {
    selectLocationIndex.value = index;
    update();
  }

  @override
  void onInit() {
    selectedLocation;

    Future.delayed(const Duration(seconds: 3)).then(
      (_) {
        if (box.read("showBottomSheet") == null) {
          Get.bottomSheet(
            ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                child: Obx(
                  () => Container(
                    height: 400,
                    color: Get.theme.colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Select Location",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: ColorCodes.white,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorCodes.teal,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 14),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: ColorCodes.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: List.generate(
                              2,
                              (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: selectLocationIndex.value == index
                                          ? ColorCodes.teal
                                          : ColorCodes.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        width: 0.4,
                                        color:
                                            selectLocationIndex.value == index
                                                ? ColorCodes.white
                                                : ColorCodes.teal,
                                      )),
                                  child: ListTile(
                                    onTap: () {
                                      selectLocationIndexToggle(index);
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    leading: CircleAvatar(
                                      maxRadius: 25,
                                      backgroundColor:
                                          selectLocationIndex.value == index
                                              ? Colors.white.withOpacity(0.3)
                                              : const Color(0xffECEDF3),
                                      child: selectLocationIndex.value == index
                                          ? const Icon(
                                              Icons.location_on,
                                              color: ColorCodes.white,
                                            )
                                          : const Icon(
                                              Icons.location_on_outlined,
                                              color: ColorCodes.teal,
                                            ),
                                    ),

                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          getElevatedButtonLarge(
                              onTap: () {
                                box.write("showBottomSheet", selectedLocation);
                                Get.back();
                              },
                              string: "Choose Location")
                        ],
                      ),
                    ),
                  ),
                )),
            barrierColor: ColorCodes.teal.withOpacity(0.8),
            isDismissible: false,
            enableDrag: false,
          );
        }
      },
    );
    // TODO: implement onInit
    super.onInit();
  }
}
