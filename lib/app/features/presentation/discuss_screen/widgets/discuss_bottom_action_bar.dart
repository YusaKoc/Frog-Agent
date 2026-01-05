import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/view/voting_screen.dart';

class DiscussBottomActionBar extends StatelessWidget {
  const DiscussBottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7ed6a3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            elevation: 1.5,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VotingScreen()),
            );
          },
          icon: const Icon(Icons.how_to_vote),
          label: const Text("Eleme Turuna Geç"),
        ),
      ),
    );
  }
}
