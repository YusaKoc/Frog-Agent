import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/widgets/voting_bottom_info.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/widgets/voting_info_card.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/widgets/voting_player_list.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFc1fba4), Color(0xFF7ed6a3)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              const VotingInfoCard(),
              const SizedBox(height: 8),
              const VotingPlayerList(),
              const VotingBottomInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
