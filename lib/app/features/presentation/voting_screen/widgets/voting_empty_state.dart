import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/view/discuss_screen.dart';

class VotingEmptyState extends StatelessWidget {
  const VotingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetPaths.citizenFrog,
              width: 90,
            ),
            const SizedBox(height: 12),
            Text(
              "Aktif oyuncu kalmadı.",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2e7d5b),
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Yeni bir eleme yapmak için yeterli oyuncu yok.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed6a3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DiscussScreen()),
                  (r) => false,
                );
              },
              child: const Text("Geri Dön"),
            ),
          ],
        ),
      ),
    );
  }
}
