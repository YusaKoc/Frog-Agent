import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';

class SpeakingOrderEmptyState extends StatelessWidget {
  const SpeakingOrderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetPaths.citizenFrog,
            width: 80,
          ),
          const SizedBox(height: 10),
          Text(
            "Konuşma sırası hazırlanıyor...",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2e7d5b),
                ),
          ),
        ],
      ),
    );
  }
}

