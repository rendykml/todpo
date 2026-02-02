import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }
}
