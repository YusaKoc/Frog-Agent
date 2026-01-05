import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_state.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/widgets/voting_empty_state.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/widgets/voting_player_card.dart';
import 'package:frog_agent/app/features/presentation/voting_screen/actions/voting_actions.dart';

class VotingPlayerList extends StatelessWidget {
  const VotingPlayerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlayerCubit, PlayerState>(
        builder: (context, state) {
          final players = state.activePlayers;

          if (players.isEmpty) {
            return const VotingEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: players.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final player = players[i];
              return VotingPlayerCard(
                player: player,
                onVote: () => votePlayer(context, player.name),
              );
            },
          );
        },
      ),
    );
  }
}
