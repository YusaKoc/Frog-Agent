// --- Boş durum ---
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/agent_frog.png", width: 120),
            const SizedBox(height: 12),
            Text(
              'Henüz grup yok',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Oyuncu listelerini gruplar olarak kaydet; sonra tek dokunuşla oyunu başlat.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Yeni Grup Oluştur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed6a3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
