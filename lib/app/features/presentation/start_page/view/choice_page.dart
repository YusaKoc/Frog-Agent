import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/view/player_setup_screen.dart';
import 'package:frog_agent/app/features/presentation/start_page/widgets/choice_button.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFc1fba4), Color(0xFF7ed6a3)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetPaths.agentFrog,
                    width: 100,
                    height: 100,
                  ),
                  const Text(
                    "FROG AGENT",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ChoiceButton(
                    title: "Oyuna Başla",
                    subtitle: "Tek başına veya aynı cihazda",
                    icon: Icons.smartphone,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PlayerSetupScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
