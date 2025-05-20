import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class NfcScanAnimation extends StatelessWidget {
  const NfcScanAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BitcoinLockerTheme.surfaceColor,
            ),
          ),
          Icon(
            Icons.contactless_rounded,
            size: 100,
            color: BitcoinLockerTheme.primaryOrange,
          ),
        ],
      ),
    );
  }
}