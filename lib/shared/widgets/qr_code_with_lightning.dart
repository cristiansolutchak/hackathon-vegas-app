import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWithLightning extends StatelessWidget {
  final String data;
  final double size;

  const QrCodeWithLightning({
    super.key,
    required this.data,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: BitcoinLockerTheme.primaryOrange.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 250 - 20,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
          ),
          Container(
            width: size * 0.2,
            height: size * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.05),
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Center(
              child: Text(
                '⚡',
                style: TextStyle(
                  fontSize: size * 0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

