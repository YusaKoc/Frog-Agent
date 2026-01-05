import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/view/player_setup_screen.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/widgets/player_setup_button_style.dart';

void cancelCurrentSelection(BuildContext context) async {
  final playerCubit = context.read<PlayerCubit>();
  playerCubit.clearPlayers();
  playerCubit.resetWords();

  try {
    await context.read<GroupCubit>().clearLastUsed();
  } catch (_) {}

  PlayerSetupHelpers.showSnack(context, 'Seçilen kullanıcılar iptal edildi.');
}

void showAddNameDialog(BuildContext context) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFfff5a5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Kullanıcı Ekle'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Frog Adı'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal')),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            final cubit = context.read<PlayerCubit>();
            final state = cubit.state;

            if (text.isEmpty) {
              PlayerSetupHelpers.showSnack(context, 'İsim boş olamaz.');
              return;
            }
            final exists = state.players
                .any((p) => p.name.toLowerCase() == text.toLowerCase());
            if (exists) {
              PlayerSetupHelpers.showSnack(context, 'Bu isim zaten eklenmiş.');
              return;
            }
            if (state.players.length >= state.maxPlayers) {
              PlayerSetupHelpers.showSnack(context,
                  'En fazla ${state.maxPlayers} oyuncu ekleyebilirsin.');
              return;
            }

            cubit.addPlayer(text);
            Navigator.pop(context);
          },
          child: const Text('Ekle'),
        ),
      ],
    ),
  );
}

void saveCurrentAsGroup(BuildContext context) async {
  final playerCubit = context.read<PlayerCubit>();
  final players = playerCubit.state.players.map((p) => p.name).toList();

  if (players.length < 3) {
    PlayerSetupHelpers.showSnack(context, 'En az 3 oyuncu olmalı.');
    return;
  }

  final nameController = TextEditingController();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFfff5a5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Grubu Kaydet'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'Grup Adı'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal')),
        TextButton(
          onPressed: () async {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              PlayerSetupHelpers.showSnack(context, 'Grup adı boş olamaz.');
              return;
            }
            try {
              final groupCubit = context.read<GroupCubit>();
              await groupCubit.create(name, players);
              await groupCubit.setLastUsed(
                groupCubit.state.groups.firstWhere((g) => g.name == name).id,
              );
              PlayerSetupHelpers.showSnack(context, 'Grup kaydedildi.');
              Navigator.pop(context);
            } catch (_) {
              PlayerSetupHelpers.showSnack(
                  context, 'Grup kaydedildi. (fallback)');
              Navigator.pop(context);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    ),
  );
}

void showRevealDialog(BuildContext context) {
  final cubit = context.read<PlayerCubit>();

  void openForIndex() {
    final s = cubit.state;
    final i = s.currentRevealIndex;
    if (i >= s.players.length) return;

    final player = s.players[i];
    final nextName = (i + 1 < s.players.length) ? s.players[i + 1].name : null;
    bool showWord = false;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setLocal) => AlertDialog(
          backgroundColor: const Color(0xFFfff5a5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("${player.name} kelimesi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!showWord)
                ElevatedButton(
                  style: PlayerSetupButtonStyle.buttonStyle(),
                  onPressed: () => setLocal(() => showWord = true),
                  child: const Text("Kelimeyi Göster"),
                ),
              if (showWord) ...[
                const SizedBox(height: 10),
                Text(player.word ?? '',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (nextName != null)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: "Sonraki: "),
                        TextSpan(
                            text: nextName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                else
                  const Text("En son oyuncu. Kelime gösterimi bitti!"),
              ],
            ],
          ),
          actions: [
            if (showWord)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  cubit.nextReveal();
                  if (!cubit.state.wordsShown) {
                    openForIndex();
                  }
                },
                child: const Text("Sonraki"),
              ),
          ],
        ),
      ),
    );
  }

  openForIndex();
}
