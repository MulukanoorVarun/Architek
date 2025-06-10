import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  static const Map<int, Color> primary = {
    100: Color(0xFFE6ECF5),
    200: Color(0xFFC3D0E7),
    300: Color(0xFF9FB4D9),
    400: Color(0xFF7C98CC),
    500: Color(0xFF587CBE),
    600: Color(0xFF3760B0),
    700: Color(0xFF2B4C7E), // Main primary color
    800: Color(0xFF1A3356),
    900: Color(0xFF0A192E),
  };

  static const Map<int, Color> secondary = {
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEBEBEB),
    300: Color(0xFFD9D9D9), // Main secondary color
    400: Color(0xFFC4C4C4),
    500: Color(0xFFAFAFAF),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  };

  static const Map<int, Color> accent = {
    100: Color(0xFFF9E9E5),
    200: Color(0xFFF3D3C9),
    300: Color(0xFFECBCAD),
    400: Color(0xFFE6A692),
    500: Color(0xFFE09076),
    600: Color(0xFFD97A5A),
    700: Color(0xFFC45C3C),
    800: Color(0xFFA44A2F),
    900: Color(0xFF833921),
  };

  static const Map<int, Color> success = {
    100: Color(0xFFE7F5E9),
    200: Color(0xFFC7E9CA),
    300: Color(0xFFA1D9A7),
    400: Color(0xFF7BC985),
    500: Color(0xFF55B962),
    600: Color(0xFF449F50),
    700: Color(0xFF34853F),
    800: Color(0xFF246B2E),
    900: Color(0xFF14511C),
  };

  static const Map<int, Color> warning = {
    100: Color(0xFFFFF8E6),
    200: Color(0xFFFFEFC4),
    300: Color(0xFFFFE69F),
    400: Color(0xFFFFDD7A),
    500: Color(0xFFFFD455),
    600: Color(0xFFFFC123),
    700: Color(0xFFF5B300),
    800: Color(0xFFC99300),
    900: Color(0xFF9C7200),
  };

  static const Map<int, Color> error = {
    100: Color(0xFFFCEAEA),
    200: Color(0xFFF8CFCF),
    300: Color(0xFFF5B4B4),
    400: Color(0xFFF19999),
    500: Color(0xFFEE7E7E),
    600: Color(0xFFEB6363),
    700: Color(0xFFE74848),
    800: Color(0xFFD42323),
    900: Color(0xFFAA1C1C),
  };

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}