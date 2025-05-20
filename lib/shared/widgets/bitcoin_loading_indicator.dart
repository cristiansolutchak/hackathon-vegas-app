import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class BitcoinLoadingIndicator extends StatelessWidget {
  final String message;
  final double size;

  const BitcoinLoadingIndicator({
    super.key,
    this.message = 'Carregando...',
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              BitcoinLockerTheme.primaryOrange,
            ),
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: BitcoinLockerTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
