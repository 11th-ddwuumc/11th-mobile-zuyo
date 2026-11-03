import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class SignupField extends StatelessWidget {
  const SignupField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.validator,
    required this.showValidation,
    this.obscureText = false,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.errorText,
    this.showLabel = true,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final bool showValidation;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final String? errorText;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final localError = validator(controller.text);
    final errorMessage = errorText ?? localError;
    final isValid = errorMessage == null;
    final hasError = errorText != null || (showValidation && localError != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        if (showLabel)
          Text(
            label,
            style: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: showValidation
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: AppTextStyles.bodyLargeMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hint,
            hintStyle: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.neutral800,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            isDense: true,
            filled: true,
            fillColor: hasError ? AppColors.errorBase : AppColors.low,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBC4D2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary500),
            ),

            // 에러
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),

            suffixIcon: showValidation
                ? Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: SvgPicture.asset(
                      isValid
                          ? 'assets/icons/check_circle.svg'
                          : 'assets/icons/error.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        isValid ? AppColors.primary500 : AppColors.error,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
