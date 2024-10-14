
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController with SingleGetTickerProviderMixin {
  int selectedIndex = 0;
  List<int>? isSelectedIndex;
  List<String> propertyImages = [];
  List<String> propertyTitles = [];
  AnimationController? colorAnimationController;
  AnimationController? textAnimationController;
  Animation<Color?>? colorTween;
  Animation<Offset>? transTween;

  @override
  void onInit() {
    super.onInit();


    colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust duration as needed
    );

    textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust duration as needed
    );

    transTween = Tween(begin: const Offset(-10, 40), end: const Offset(-10, 0))
        .animate(textAnimationController!);
  }



  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      if (colorAnimationController != null && textAnimationController != null) {
        colorAnimationController!.animateTo(scrollInfo.metrics.pixels / 100);
        textAnimationController!.animateTo((scrollInfo.metrics.pixels - 30) / 50);
        return true;
      }
    }
    return false;
  }


  void selectedIndexToggle(int index) {
    selectedIndex = index;
    update();
  }

  @override
  @override
  void dispose() {
    colorAnimationController?.dispose();
    textAnimationController?.dispose();
    super.dispose();
  }


  // Predefined lists for the UI
  List<String> Cat = ["All", "House", "Apartment", "Villa"];
}



