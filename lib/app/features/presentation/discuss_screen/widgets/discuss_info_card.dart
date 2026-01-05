import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';

class DiscussInfoCard extends StatelessWidget {
  const DiscussInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: const Color(0xFFfff5a5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.agentFrog,
                width: math.min(MediaQuery.of(context).size.width * 0.12, 56),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tartışma Zamanı",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: const Color(0xFF4aa96c),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Gizli kelimenizi belirtilen sırayla yalnızca bir kelime veya kısa bir ifade ile anlatın.",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

