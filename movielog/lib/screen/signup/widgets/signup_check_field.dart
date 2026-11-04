import 'package:flutter/material.dart';
import 'package:movielog/screen/signup/widgets/signup_field.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/widgets/movielog_button.dart';

class SignupCheckField extends StatelessWidget {
  const SignupCheckField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.showValidation,
    required this.onChanged,
    required this.status,
    required this.onCheck,
    this.errorText,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool showValidation;
  final ValueChanged<String> onChanged;
  final CheckStatus status;
  final VoidCallback? onCheck;
  final String? errorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLargeMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SignupField(
                label: label,
                hint: hint,
                controller: controller,
                validator: validator,
                showValidation: showValidation,
                showLabel: false,
                errorText: errorText,
                focusNode: focusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: onFieldSubmitted,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 8),
            MovieLogButton(
              label: '중복 확인',
              isLoading: status == CheckStatus.checking,
              onPressed: onCheck,
            ),
          ],
        ),
        if (status == CheckStatus.available)
          Text(
            '사용할 수 있는 $label입니다.',
            style: AppTextStyles.labelSmallBold.copyWith(
              fontSize: 12,
              color: const Color(0xFF2E7D32),
            ),
          ),
      ],
    );
  }
}
