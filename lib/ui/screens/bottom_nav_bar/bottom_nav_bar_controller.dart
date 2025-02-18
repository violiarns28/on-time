import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  final selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
    update();
  }
}
