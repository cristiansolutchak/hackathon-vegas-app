import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class BitcoinLockerIcon extends StatelessWidget {
  final String state;
  final double size;

  const BitcoinLockerIcon({
    super.key,
    required this.state,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (state.toLowerCase()) {
      case 'available':
        color = BitcoinLockerTheme.success;
        icon = Icons.lock_open_rounded;
        break;
      case 'in_use':
      case 'occupied':
        color = BitcoinLockerTheme.error;
        icon = Icons.lock_rounded;
        break;
      default:
        color = BitcoinLockerTheme.info;
        icon = Icons.lock_rounded;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: BitcoinLockerTheme.surfaceColor,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: size * 0.6,
        ),
      ),
    );
  }
}