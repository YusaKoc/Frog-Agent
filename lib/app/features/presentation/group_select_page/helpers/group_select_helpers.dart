// ---- Helper Functions ----

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/player_setup_screen/view/player_setup_screen.dart';

Future<bool?> confirmDelete(BuildContext context, PlayerGroup g) async {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFfff5a5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Grubu Sil'),
      content: Text("'${g.name}' silinsin mi?"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Sil'),
        ),
      ],
    ),
  );
}

void quickStart(BuildContext context, PlayerGroup g) {
  final playerCubit = context.read<PlayerCubit>();
  playerCubit.setPlayers(g.players);
  playerCubit.assignWords();
  context.read<GroupCubit>().setLastUsed(g.id);

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
  );
}

void createGroup(BuildContext context) {
  final nameController = TextEditingController();
  final playersController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Text('Yeni Grup',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration:
                const InputDecoration(labelText: 'Grup Adı', filled: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: playersController,
            decoration: const InputDecoration(
              labelText: 'Oyuncular (virgülle ayır: Ali, Veli, Ayşe)',
              filled: true,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed6a3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                final raw = playersController.text.trim();
                final players = raw
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toSet()
                    .toList();
                if (name.isEmpty || players.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ad ve en az bir oyuncu gerekli.')),
                  );
                  return;
                }
                await context.read<GroupCubit>().create(name, players);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ),
        ],
      ),
    ),
  );
}

void editGroup(BuildContext context, PlayerGroup g) {
  final nameController = TextEditingController(text: g.name);
  final playersController = TextEditingController(text: g.players.join(', '));

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Text('Grubu Düzenle',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration:
                const InputDecoration(labelText: 'Grup Adı', filled: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: playersController,
            decoration: const InputDecoration(
                labelText: 'Oyuncular (virgülle ayır)', filled: true),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed6a3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                final raw = playersController.text.trim();
                final players = raw
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toSet()
                    .toList();
                await context.read<GroupCubit>().update(
                      g.copyWith(name: name, players: players),
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Güncelle'),
            ),
          ),
        ],
      ),
    ),
  );
}

void saveCurrentAsGroup(BuildContext context) {
  final playerCubit = context.read<PlayerCubit>();
  final players = playerCubit.state.players.map((p) => p.name).toList();

  if (players.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Önce oyuncu ekleyin.')),
    );
    return;
  }

  final nameController = TextEditingController();
  showDialog(
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
            if (name.isEmpty) return;
            await context.read<GroupCubit>().create(name, players);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grup kaydedildi.')),
              );
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    ),
  );
}
