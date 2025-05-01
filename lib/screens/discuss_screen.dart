import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/player_provider.dart';
import 'voting_screen.dart';

class DiscussScreen extends ConsumerWidget {
  const DiscussScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playerProvider.notifier);
    notifier.generateSpeakingOrder();
    final speakingOrder = notifier.getSpeakingOrder;

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              color: const Color(0xFFfff5a5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Image.asset("assets/images/agent_frog.png", width: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Discuss Time", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Color(0xFF4aa96c),)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Describe your secret word in the specified order using only one word or phrase.",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: speakingOrder.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Image.asset("assets/images/citizen_frog.png", width: 50),
                        const SizedBox(width: 12),
                        Text(
                          "${index + 1}. ${speakingOrder[index]}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 20.0,top: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ed6a3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  elevation: 4,
                ),
                child: const Text("Start Voting"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VotingScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
