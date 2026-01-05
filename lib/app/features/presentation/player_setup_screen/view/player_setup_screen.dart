import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/actions/actions.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/add_player_section.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/bottom_action_bar.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/hero_section.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/info_text.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/player_controls.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/player_list.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/selected_users_banner.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/view/discuss_screen.dart';
import '../../cubit/local/player_cubit.dart';
import '../../cubit/local/player_state.dart';

class PlayerSetupScreen extends StatelessWidget {
  const PlayerSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

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
          child: BlocBuilder<PlayerCubit, PlayerState>(
            builder: (context, state) {
              final players = state.players;
              final screenW = MediaQuery.of(context).size.width;
              final heroImageW = math.min(screenW * 0.45, 180.0);

              return Stack(
                children: [
                  CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Column(
                            children: [
                              HeroSection(heroImageWidth: heroImageW),
                              const SizedBox(height: 12),
                              if (players.isNotEmpty && !state.wordsShown)
                                SelectedUsersBanner(
                                  playerCount: players.length,
                                  onCancel: () =>
                                      cancelCurrentSelection(context),
                                ),
                              if (players.isNotEmpty && !state.wordsShown)
                                const SizedBox(height: 12),
                              if (!state.wordsAssigned)
                                PlayerControls(
                                  maxPlayers: state.maxPlayers,
                                  onMaxPlayersChanged: (v) =>
                                      cubit.setMaxPlayers(v),
                                ),
                              if (!state.wordsAssigned)
                                const SizedBox(height: 10),
                              if (!state.wordsAssigned)
                                AddPlayerSection(
                                  canAdd: players.length < state.maxPlayers,
                                  onAdd: () => showAddNameDialog(context),
                                  onClear: cubit.clearPlayers,
                                ),
                              const SizedBox(height: 10),
                              const InfoText(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      PlayerList(
                        players: players,
                        wordsAssigned: state.wordsAssigned,
                        onRemovePlayer: (name) => cubit.removePlayer(name),
                      ),
                    ],
                  ),
                  BottomActionBar(
                    players: players,
                    state: state,
                    cubit: cubit,
                    onSaveAsGroup: () => saveCurrentAsGroup(context),
                    onShowReveal: () => showRevealDialog(context),
                    onStartGame: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DiscussScreen()),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PlayerSetupHelpers {
  static void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
