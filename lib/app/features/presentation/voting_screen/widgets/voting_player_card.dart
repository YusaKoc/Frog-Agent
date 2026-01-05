import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/data/local/entity/player_entity.dart';

class VotingPlayerCard extends StatelessWidget {
  const VotingPlayerCard({
    super.key,
    required this.player,
    required this.onVote,
  });

  final Player player;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFc1fba4),
          child: Text(
            player.name.characters.first.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF2e7d5b),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: const Text("Aday"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          onPressed: onVote,
          child: const Text("Ele"),
        ),
        onTap: onVote,
      ),
    );
  }
}

