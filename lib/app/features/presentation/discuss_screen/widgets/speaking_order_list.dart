import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_state.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/widgets/speaker_card.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/widgets/speaking_order_empty_state.dart';

class SpeakingOrderList extends StatelessWidget {
  const SpeakingOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PlayerCubit, PlayerState>(
        builder: (context, state) {
          final order = state.speakingOrder;

          if (order.isEmpty) {
            return const SpeakingOrderEmptyState();
          }

          // Oyuncu isimlerinden Player objelerine eşleştir
          final playerMap = {
            for (final player in state.players) player.name: player
          };

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 140),
            itemCount: order.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final name = order[index];
              final player = playerMap[name];
              final isEliminated = player?.isEliminated ?? false;
              final isFirst = index == 0 && !isEliminated;
              return SpeakerCard(
                name: name,
                index: index + 1,
                isFirst: isFirst,
                isEliminated: isEliminated,
              );
            },
          );
        },
      ),
    );
  }
}
