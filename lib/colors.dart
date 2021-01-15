import 'dart:math';

import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1,
    );

int shadeValue(int value, double factor) => max(
      0,
      min(value - (value * factor).round(), 255),
    );

Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1,
    );

// Colors
const Color BLUE = Color(0xFF8280FF);
const Color LIGHT_BLUE = Color(0xFFE8E7FF);

const Color RED = Color(0xFFFF7285);
const Color LIGHT_RED = Color(0xFFFFE2E7);

const Color YELLOW = Color(0xFFFFCA83);
const Color LIGHT_YELLOW = Color(0xFFFFF4E5);

const Color GREEN = Color(0xFF4AD991);
const Color LIGHT_GREEN = Color(0xFFDAF7E8);

const Color LIGHT_GREY = Color(0xFFF0F0F7);
const Color GREY = Color(0xFFB4B4C6);
const Color DARK_GREY = Color(0xFF707070);
