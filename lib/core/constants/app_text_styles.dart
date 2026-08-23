// core/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Text — Source Sans Pro, 96/700
  static const display96 = TextStyle(
    fontFamily: 'SourceSansPro',
    fontSize: 96,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1.92, // 2%
    color: AppColors.white,
  );

  // Headline 28 bold — Dancing Script
  static const headline28 = TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.168, // -0.6%
    color: AppColors.white,
  );

  // "Black Tie Classic" стилдеги карточка аталышы — Dancing Script 20 bold
  static const script20 = TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.12, // -0.6%
    color: AppColors.white,
  );

  // Title 21 semibold — Raleway
  static const title21 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 21,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.42, // 2%
    color: AppColors.white,
  );

  // Body 17 Medium — Raleway (реалдуу size 16)
  static const body16 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.32, // 2%
    color: AppColors.white,
  );

  // Caption 12 Medium — Raleway (реалдуу weight Regular)
  static const caption12 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.white,
  );

  // Suits — Dancing Script 28 bold (headline28 менен бирдей, өзүнчө семантика үчүн)
  static const suits = TextStyle(
    fontFamily: 'DancingScript',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.168, // -0.6%
    color: AppColors.white,
  );

    static const captionBold12 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.white,
  );

}