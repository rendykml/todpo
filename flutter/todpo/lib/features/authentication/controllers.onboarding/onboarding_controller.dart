import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todpo/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  //variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigation(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage() {
    // Logic to navigate to the next page
    if (currentPageIndex.value < 2) {
      currentPageIndex.value += 1;
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(const LoginScreen());
    }
  }

  void backPage() {
    // Logic to navigate to the previous page
    if (currentPageIndex.value > 0) {
      currentPageIndex.value -= 1;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Already at the first page, do nothing or handle accordingly
    }
  }

  void skipPage() {
    // Logic to skip to the last page
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
