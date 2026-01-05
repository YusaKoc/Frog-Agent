import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.heroImageWidth});

  final double heroImageWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "FROG AGENT",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2e7d5b),
              ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          AssetPaths.agentFrog,
          width: heroImageWidth,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
