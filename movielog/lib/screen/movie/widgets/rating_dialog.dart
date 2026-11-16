import 'package:flutter/material.dart';
import 'package:movielog/models/rating_request.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/screen/movie/widgets/movie_rating_input.dart';
import 'package:movielog/widgets/movielog_button.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({
    super.key,
    this.initialScore = 0,
    this.initialComment,
    required this.onSubmit,
  });

  final int initialScore;
  final String? initialComment;
  final Future<void> Function(int score, String? comment) onSubmit;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int _score = widget.initialScore;
  late final _commentController = TextEditingController(
    text: widget.initialComment ?? '',
  );
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Dialog(
        backgroundColor: AppColors.lowest,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '평점을 남겨주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: MovieRatingInput(
                      rating: _score.toDouble(),
                      enabled: !_isSubmitting,
                      onChanged: (value) =>
                          setState(() => _score = validateServerScore(value)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '코멘트 (선택, 최대 500자)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.selectedIcon,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  minLines: 4,
                  maxLines: 4,
                  maxLength: 500,
                  enabled: !_isSubmitting,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '이 영화의 인상적인 장면은...',
                    hintStyle: const TextStyle(color: AppColors.neutral800),
                    filled: true,
                    fillColor: const Color(0xFFFAF8FC),
                    counterText: '',
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD8D2E1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFD8D2E1),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary500,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorText!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: MovieLogButton(
                        label: '취소',
                        backgroundColor: const Color(0xFFF0EAF8),
                        foregroundColor: AppColors.primary500,
                        borderRadius: 999,
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.pop(context, false),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: MovieLogButton(
                        label: '확인',
                        borderRadius: 999,
                        isLoading: _isSubmitting,
                        onPressed: _score > 0 && !_isSubmitting
                            ? _onConfirm
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    final trimmed = _commentController.text.trim();
    if (trimmed.length > 500) {
      setState(() {
        _isSubmitting = false;
        _errorText = '코멘트는 500자 이하로 입력해 주세요.';
      });
      return;
    }
    try {
      await widget.onSubmit(_score, trimmed.isEmpty ? null : trimmed);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorText = '저장하지 못했습니다. 잠시 후 다시 시도해 주세요.';
      });
    }
  }
}
