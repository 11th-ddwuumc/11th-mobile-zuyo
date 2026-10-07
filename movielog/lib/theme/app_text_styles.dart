import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  // Title Large
  static const titleLargeRegular = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static final titleLargeMedium = titleLargeRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final titleLargeSemiBold = titleLargeRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final titleLargeBold = titleLargeRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Title Medium
  static const titleMediumRegular = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static final titleMediumMedium = titleMediumRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final titleMediumSemiBold = titleMediumRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final titleMediumBold = titleMediumRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Body Large
  static const bodyLargeRegular = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );

  static final bodyLargeMedium = bodyLargeRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final bodyLargeSemiBold = bodyLargeRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final bodyLargeBold = bodyLargeRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Body Medium
  static const bodyMediumRegular = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  static final bodyMediumMedium = bodyMediumRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final bodyMediumSemiBold = bodyMediumRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final bodyMediumBold = bodyMediumRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Label Large
  static const labelLargeRegular = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w400,
  );

  static final labelLargeMedium = labelLargeRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final labelLargeSemiBold = labelLargeRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final labelLargeBold = labelLargeRegular.copyWith(
    fontWeight: FontWeight.w700,
  );

  // Label Small
  static const labelSmallRegular = TextStyle(
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );

  static final labelSmallMedium = labelSmallRegular.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final labelSmallSemiBold = labelSmallRegular.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final labelSmallBold = labelSmallRegular.copyWith(
    fontWeight: FontWeight.w700,
  );
}