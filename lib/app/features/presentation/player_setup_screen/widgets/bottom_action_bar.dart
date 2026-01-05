import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/data/local/entity/player_entity.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_state.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/player_setup_button_style.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.players,
    required this.state,
    required this.cubit,
    required this.onSaveAsGroup,
    required this.onShowReveal,
    required this.onStartGame,
  });

  final List<Player> players;
  final PlayerState state;
  final PlayerCubit cubit;
  final VoidCallback onSaveAsGroup;
  final VoidCallback onShowReveal;
  final VoidCallback onStartGame;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (players.length >= state.maxPlayers && !state.wordsAssigned)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: PlayerSetupButtonStyle.buttonStyle(),
                  onPressed: onSaveAsGroup,
                  icon: const Icon(Icons.save),
                  label: const Text('Gruplara kaydet'),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (players.length == state.maxPlayers && !state.wordsAssigned)
                  Expanded(
                    child: ElevatedButton(
                      style: PlayerSetupButtonStyle.buttonStyle(),
                      onPressed: cubit.assignWords,
                      child: const Text("Harfleri Ata"),
                    ),
                  ),
                if (players.length == state.maxPlayers && !state.wordsAssigned)
                  const SizedBox(width: 12),
                if (state.wordsAssigned && !state.wordsShown)
                  Expanded(
                    child: ElevatedButton(
                      style: PlayerSetupButtonStyle.buttonStyle(),
                      onPressed: onShowReveal,
                      child: const Text("Kelimeyi Göster"),
                    ),
                  ),
                if (state.wordsAssigned && state.wordsShown)
                  Expanded(
                    child: ElevatedButton(
                      style: PlayerSetupButtonStyle.buttonStyle(),
                      onPressed: onStartGame,
                      child: const Text("Oyuna Başla"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

