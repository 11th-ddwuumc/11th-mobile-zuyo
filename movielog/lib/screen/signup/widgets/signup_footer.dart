import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class SignupFooter extends StatelessWidget {
  const SignupFooter({
    super.key,
    required this.agreed,
    required this.onAgreementChanged,
    required this.onSubmit,
  });

  final bool agreed;
  final ValueChanged<bool> onAgreementChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Row(
            children: [
              Checkbox(
                value: agreed,
                activeColor: AppColors.primary500,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  onAgreementChanged(value ?? false);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '필수 약관에 동의합니다',
                  style: AppTextStyles.bodyLargeMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.secondary300,
                disabledForegroundColor: AppColors.lowest,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '가입하기',
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.lowest,
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '이미 계정이 있나요? ',
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '로그인', 
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
