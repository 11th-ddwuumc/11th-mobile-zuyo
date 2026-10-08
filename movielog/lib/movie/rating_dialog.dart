import 'package:flutter/material.dart';
import 'package:movielog/movie/movie_rating_input.dart';
import 'package:movielog/theme/app_colors.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.base,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '영화는 어떠셨나요?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF25232A)
              ),
            ),
            
            const SizedBox(height: 24),
						
            MovieRatingInput(
						  rating: rating,
						  onChanged: (value) {
						    setState(() {
						      rating = value;
						    });
						  },
						),

            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: rating > 0
                  ? () => Navigator.pop(context, rating)
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: AppColors.lowest,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}