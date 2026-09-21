import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class SignupField extends StatelessWidget{
  const SignupField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.validator,
    required this.showValidation,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final bool showValidation;

  @override
  Widget build(BuildContext context) {
    final errorMessage = validator(controller.text);
    final isValid = validator(controller.text) == null;
    final hasError = showValidation && !isValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLargeMedium.copyWith(
            color: AppColors.textPrimary
          ),
        ),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: showValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
          style: AppTextStyles.bodyLargeMedium.copyWith(
            color: AppColors.textPrimary
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.neutral800
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            isDense: true,
            filled: true,
            fillColor: hasError ? AppColors.errorBase : AppColors.base,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFCBC4D2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary500,
              ),
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
              ? Icon(
                isValid ? Icons.check_circle : Icons.error_outline,
                color: isValid ? AppColors.primary500 : AppColors.error,
                size: 20
              )
              : null
          ),
          errorBuilder: (context, errorText) => const SizedBox.shrink(),
        ),
        if(hasError)
          Text(
            errorMessage!,
            style: AppTextStyles.labelSmallMedium.copyWith(
              fontSize: 12,
              color: AppColors.error
            )
          )
      ],
    );
  }
}
