import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const FavoriteButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
            )
          : IconButton(
              icon: const Icon(Icons.favorite_border, size: 28),
              color: Colors.black,
              onPressed: onPressed,
            ),
    );
  }
}
