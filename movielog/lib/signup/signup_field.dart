import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';

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
    final isValid = validator(controller.text) == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [
        Text(label),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: showValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            suffixIcon: showValidation
              ? Icon(
                isValid ? Icons.check_circle : Icons.error_outline,
                color: isValid ? AppColors.primary500 : AppColors.error
              )
              : null
          ),
        )
      ],
    );
  }
}
