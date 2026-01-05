import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/discuss_screen/view/discuss_screen.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/view/player_setup_screen.dart';

void votePlayer(BuildContext context, String playerName) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFfff5a5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Onayla"),
      content: Text("'$playerName' kişisini elemek istediğine emin misin?"),
      actions: [
        TextButton(
          child: const Text("İptal"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Ele"),
          onPressed: () {
            Navigator.pop(context);
            final cubit = context.read<PlayerCubit>();
            final isDisguised = cubit.isDisguised(playerName);

            cubit.eliminatePlayer(playerName);

            if (isDisguised) {
              showGameOverDialog(
                context,
                "🎉 Köylü kurbağalar kazandı!",
                cubit,
              );
            } else if (cubit.checkWinCondition()) {
              showGameOverDialog(
                context,
                "😈 Gizlenmiş kurbağa kazandı!",
                cubit,
              );
            } else {
              showCitizenEliminatedDialog(context, playerName);
            }
          },
        ),
      ],
    ),
  );
}

void showCitizenEliminatedDialog(BuildContext context, String playerName) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFfff5a5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Köylü Kurbağa Elendi"),
      content: Text("$playerName bir köylü kurbağa olarak elendi!"),
      actions: [
        TextButton(
          child: const Text("Devam"),
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

void showGameOverDialog(
  BuildContext context,
  String title,
  PlayerCubit cubit,
) {
  final state = cubit.state;
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
          Text("🐸 Köylü kurbağa kelimesi: ${state.commonWord ?? '-'}"),
          Text("😈 Gizli kurbağa kelimesi: ${state.disguisedWord ?? '-'}"),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Yeni Oyun"),
          onPressed: () {
            cubit.resetGame();
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
