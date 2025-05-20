import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class BitcoinStatusBadge extends StatelessWidget {
  final String status;

  const BitcoinStatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case 'available':
        backgroundColor = BitcoinLockerTheme.success.withValues(alpha: 0.2);
        textColor = BitcoinLockerTheme.success;
        label = 'Available';
        break;
      case 'your_reservation':
        backgroundColor = BitcoinLockerTheme.warningColor.withValues(
          alpha: 0.2,
        );
        textColor = BitcoinLockerTheme.warningColor;
        label = 'Your reservation';
        break;
      case 'reserved':
        backgroundColor = BitcoinLockerTheme.error.withValues(alpha: 0.2);
        textColor = BitcoinLockerTheme.error;
        label = 'Reserved';
        break;
      case 'in_use':
        backgroundColor = BitcoinLockerTheme.error.withValues(alpha: 0.2);
        textColor = BitcoinLockerTheme.error;
        label = 'In use';
        break;
      default:
        backgroundColor = BitcoinLockerTheme.textSecondary.withValues(
          alpha: 0.2,
        );
        textColor = BitcoinLockerTheme.textSecondary;
        label = 'Unavailable';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: BitcoinLockerTheme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
