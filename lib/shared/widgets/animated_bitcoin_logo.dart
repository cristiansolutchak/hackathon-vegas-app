import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class AnimatedBitcoinLogo extends StatelessWidget {
  final double size;

  const AnimatedBitcoinLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: BitcoinLockerTheme.darkBackground,
          boxShadow: [
            BoxShadow(
              color: BitcoinLockerTheme.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: BitcoinLockerTheme.primaryOrange,
          ),
          child: Center(
            child: Text(
              '₿',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}