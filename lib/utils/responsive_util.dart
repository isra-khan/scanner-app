import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive {
  static double get width => Get.width;
  static double get height => Get.height;

  // Design base dimensions (based on standard mobile design like iPhone 11/12/13)
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  // Get proportional width
  static double w(double width) {
    return (width / _designWidth) * Get.width;
  }

  // Get proportional height
  static double h(double height) {
    return (height / _designHeight) * Get.height;
  }

  // Get proportional font size
  static double sp(double fontSize) {
    return (fontSize / _designWidth) * Get.width;
  }
}
