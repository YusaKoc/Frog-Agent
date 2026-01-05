import 'package:flutter/material.dart';

class SelectedUsersBanner extends StatelessWidget {
  const SelectedUsersBanner({
    super.key,
    required this.playerCount,
    required this.onCancel,
  });

  final int playerCount;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_alt),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Seçilen kullanıcılar: $playerCount",
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.close),
            label: const Text('Seçimi İptal Et'),
          ),
        ],
      ),
    );
  }
}
