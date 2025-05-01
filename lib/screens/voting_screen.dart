import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';
import 'player_setup_screen.dart';
import 'discuss_screen.dart';

class VotingScreen extends ConsumerWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider.notifier).activePlayers;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFc1fba4),
              Color(0xFF7ed6a3),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Card(
              color: const Color(0xFFfff5a5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  children: [
                    Image.asset("assets/images/agent_frog.png", width: 50),
                    const SizedBox(height: 8),
                    Text(
                      "Eliminate Time",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4aa96c),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Vote for the player you think is suspicious.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) {
                  final player = players[i];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            title: Text(
                              player.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            onTap: () => _votePlayer(context, ref, player.name),
                          ),
                        ),

                        Positioned(
                          right: 16,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFff6b6b),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Eliminate",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }


  void _votePlayer(BuildContext context, WidgetRef ref, String playerName) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFfff5a5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Elimination"),
        content: Text("Are you sure you want to eliminate '$playerName'?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Eliminate"),
            onPressed: () {
              Navigator.pop(context);
              final notifier = ref.read(playerProvider.notifier);
              final isDisguised = notifier.isDisguised(playerName);

              notifier.eliminatePlayer(playerName);

              if (isDisguised) {
                _showGameOverDialog(context, ref, "🎉 Citizens Win!", notifier);
              } else if (notifier.checkWinCondition()) {
                _showGameOverDialog(context, ref, "😈 Disguised Wins!", notifier);
              } else {
                _showCitizenEliminatedDialog(context, playerName);
              }
            },
          ),
        ],
      ),
    );
  }


  void _showCitizenEliminatedDialog(BuildContext context, String playerName) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFfff5a5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Citizen Eliminated"),
        content: Text("$playerName was a Citizen."),
        actions: [
          TextButton(
            child: const Text("Continue"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DiscussScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, WidgetRef ref, String title, PlayerNotifier notifier) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFfff5a5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Common Word: ${notifier.commonWord}"),
            Text("Disguised Word: ${notifier.disguisedWord}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("New Game"),
            onPressed: () {
              ref.read(playerProvider.notifier).resetGame();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
