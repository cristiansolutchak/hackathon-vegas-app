import 'package:flutter/material.dart';
import 'package:hackathon_vegas/core/theme/theme.dart';

class BitcoinCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool useGlassEffect;

  const BitcoinCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.useGlassEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: useGlassEffect
          ? BitcoinLockerTheme.glassCardDecoration
          : BitcoinLockerTheme.cardDecoration,
      padding: padding,
      child: child,
    );
  }
}