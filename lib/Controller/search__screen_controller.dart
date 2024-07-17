import 'package:get/get.dart';



class SearchScreenController extends GetxController {
  int selectedIndex = 0;

  List<int>? isSelectedVilla;

  @override
  void onInit() {
    isSelectedVilla = List<int>.filled(topVillaImage.length, -1);

    // TODO: implement onInit
    super.onInit();
  }

  void selectedIndexToggle(index) {
    selectedIndex = index;
    update();
  }

  List topVillaImage = [
    "assets/images/ApartmentImage.png",
    "assets/images/ApartmentImage.png",
  ];

}
