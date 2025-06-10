import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // Font families
  static final TextStyle _heading = GoogleFonts.playfairDisplay();
  static final TextStyle _body = GoogleFonts.roboto();

  // Font weights
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _bold = FontWeight.w700;

  // Line heights
  static const double _headingLineHeight = 1.2; // 120%
  static const double _bodyLineHeight = 1.5; // 150%

  // Display text (largest)
  static final TextStyle displayTextStyle = _heading.copyWith(
    fontSize: 40,
    fontWeight: _bold,
    height: _headingLineHeight,
    letterSpacing: -0.5,
  );

  // Heading styles
  static final TextStyle h1TextStyle = _heading.copyWith(
    fontSize: 32,
    fontWeight: _bold,
    height: _headingLineHeight,
  );

  static final TextStyle h2TextStyle = _heading.copyWith(
    fontSize: 24,
    fontWeight: _bold,
    height: _headingLineHeight,
  );

  static final TextStyle h3TextStyle = _heading.copyWith(
    fontSize: 20,
    fontWeight: _bold,
    height: _headingLineHeight,
  );

  static final TextStyle h4TextStyle = _heading.copyWith(
    fontSize: 18,
    fontWeight: _bold,
    height: _headingLineHeight,
  );

  static final TextStyle h5TextStyle = _heading.copyWith(
    fontSize: 16,
    fontWeight: _bold,
    height: _headingLineHeight,
  );

  // Body styles
  static final TextStyle bodyLargeTextStyle = _body.copyWith(
    fontSize: 16,
    fontWeight: _regular,
    height: _bodyLineHeight,
  );

  static final TextStyle bodyMediumTextStyle = _body.copyWith(
    fontSize: 14,
    fontWeight: _regular,
    height: _bodyLineHeight,
  );

  static final TextStyle captionTextStyle = _body.copyWith(
    fontSize: 12,
    fontWeight: _regular,
    height: _bodyLineHeight,
  );

  // Functional styles
  static final TextStyle buttonTextStyle = _body.copyWith(
    fontSize: 14,
    fontWeight: _medium,
    letterSpacing: 0.5,
  );

  static final TextStyle overlineTextStyle = _body.copyWith(
    fontSize: 10,
    fontWeight: _medium,
    letterSpacing: 1.5,
    height: _bodyLineHeight,
  );
}