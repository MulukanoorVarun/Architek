import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/theme/typography.dart';
import 'package:arkitek_app/theme/spacing.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary[700]!,
      onPrimary: Colors.white,
      secondary: AppColors.secondary[300]!,
      onSecondary: Colors.black,
      tertiary: AppColors.accent[700]!,
      onTertiary: Colors.white,
      error: AppColors.error[700]!,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary[700],
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary[700],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary[700],
        side: BorderSide(color: AppColors.primary[700]!),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.secondary[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.secondary[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.primary[700]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.error[700]!, width: 1),
      ),
      contentPadding: EdgeInsets.all(AppSpacing.md),
      filled: true,
      fillColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary[700],
      unselectedItemColor: AppColors.secondary[600],
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.secondary[100],
      labelStyle: GoogleFonts.roboto(
        color: AppColors.secondary[800],
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary[500]!,
      onPrimary: Colors.black,
      secondary: AppColors.secondary[600]!,
      onSecondary: Colors.white,
      tertiary: AppColors.accent[500]!,
      onTertiary: Colors.black,
      error: AppColors.error[600]!,
      onError: Colors.white,
      background: Color(0xFF121212),
      onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFF2C2C2C),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary[500],
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary[400],
        side: BorderSide(color: AppColors.primary[400]!),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.secondary[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.secondary[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.primary[400]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        borderSide: BorderSide(color: AppColors.error[600]!, width: 1),
      ),
      contentPadding: EdgeInsets.all(AppSpacing.md),
      filled: true,
      fillColor: Color(0xFF2C2C2C),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: AppColors.primary[400],
      unselectedItemColor: AppColors.secondary[400],
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      labelStyle: GoogleFonts.roboto(
        color: AppColors.secondary[300],
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    ),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light 
        ? Colors.black 
        : Colors.white;
    
    return TextTheme(
      displayLarge: AppTypography.displayTextStyle.copyWith(color: textColor),
      displayMedium: AppTypography.h1TextStyle.copyWith(color: textColor),
      displaySmall: AppTypography.h2TextStyle.copyWith(color: textColor),
      headlineMedium: AppTypography.h3TextStyle.copyWith(color: textColor),
      headlineSmall: AppTypography.h4TextStyle.copyWith(color: textColor),
      titleLarge: AppTypography.h5TextStyle.copyWith(color: textColor),
      bodyLarge: AppTypography.bodyLargeTextStyle.copyWith(color: textColor),
      bodyMedium: AppTypography.bodyMediumTextStyle.copyWith(color: textColor),
      labelLarge: AppTypography.buttonTextStyle.copyWith(color: textColor),
      bodySmall: AppTypography.captionTextStyle.copyWith(
        color: brightness == Brightness.light 
            ? AppColors.secondary[700] 
            : AppColors.secondary[300],
      ),
      labelSmall: AppTypography.overlineTextStyle.copyWith(
        color: brightness == Brightness.light 
            ? AppColors.secondary[700] 
            : AppColors.secondary[300],
      ),
    );
  }
}