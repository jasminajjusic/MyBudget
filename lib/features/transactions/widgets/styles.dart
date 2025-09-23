import 'package:flutter/material.dart';

class AppColors {
  static const backgroundColor = Color(0xFFF3F5F9);
  static const appBarColor = Color(0xFF151822);
  static const textPrimaryColor = Color(0xFF3A3B3C);
  static const textBlack = Colors.black;
  static const textRed = Colors.red;
}

class AppTextStyles {
  static const title = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: Colors.white,
    letterSpacing: -0.5,
    fontFamily: 'Montserrat-Bold',
  );

  static const category = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    color: AppColors.textBlack,
  );

  static const transactionType = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const infoText = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryColor,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
  );

  static const deleteText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textRed,
    fontFamily: 'Montserrat-Bold',
  );

  static const repeatingPaymentLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
    fontFamily: 'Montserrat-Bold',
  );

  static const footerText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryColor,
    letterSpacing: -0.24,
  );
}
