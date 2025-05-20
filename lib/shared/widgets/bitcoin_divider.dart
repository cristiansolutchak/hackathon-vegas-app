import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class BitcoinDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  const BitcoinDivider({
    super.key,
    this.height = 24,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height / 2, bottom: height / 2),
      child: Divider(
        height: 0,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: BitcoinLockerTheme.textDisabled.withValues(alpha: 0.2),
      ),
    );
  }
}