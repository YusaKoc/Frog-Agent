// lib/app/features/players/presentation/pages/player_setup_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/screens/local/group_select_page.dart';
import '../../cubit/local/player_cubit.dart';
import '../../cubit/local/player_state.dart';
import 'discuss_screen.dart';

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
                  // Ana kaydırılabilir içerik
                  CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Column(
                            children: [
                              Text(
                                "FROG AGENT",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF2e7d5b),
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                "assets/images/agent_frog.png",
                                width: heroImageW,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 12),

                              // Seçilen kullanıcılar banner (oyun başlamadan)
                              if (players.isNotEmpty && !state.wordsShown)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.people_alt),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Seçilen kullanıcılar: ${players.length}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () =>
                                            _cancelCurrentSelection(context),
                                        icon: const Icon(Icons.close),
                                        label: const Text('Seçimi İptal Et'),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 12),

                              // Kontroller (kelimeler atanmamışsa)
                              if (!state.wordsAssigned)
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF2e7d5b),
                                          side: const BorderSide(
                                              color: Color(0xFF2e7d5b)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const GroupSelectPage()),
                                          );
                                        },
                                        icon: const Icon(Icons.group),
                                        label: const Text('Gruplardan Seç'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: state.maxPlayers,
                                          items: List.generate(10, (i) => i + 3)
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text("$e Frogs 🐸"),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            if (v != null)
                                              cubit.setMaxPlayers(v);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              if (!state.wordsAssigned)
                                const SizedBox(height: 10),

                              if (!state.wordsAssigned)
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: _btnStyle(),
                                        onPressed: context
                                                    .read<PlayerCubit>()
                                                    .state
                                                    .players
                                                    .length >=
                                                context
                                                    .read<PlayerCubit>()
                                                    .state
                                                    .maxPlayers
                                            ? null
                                            : () => _showAddNameDialog(context),
                                        child: const Text('Kullanıcı Ekle'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton.filledTonal(
                                      tooltip: 'Listeyi temizle',
                                      onPressed: cubit.clearPlayers,
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 10),

                              // Bilgi metni
                              Text(
                                "Listede ilk sıradaki kurbağanın kelimesi önce gösterilir.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      // Oyuncu listesi (tek scroll içinde)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 140), // alttaki action bar için boşluk
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: players.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                              "assets/images/citizen_frog.png",
                                              width: 72),
                                          const SizedBox(height: 8),
                                          const Text("Henüz oyuncu yok"),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: players.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (_, i) => ListTile(
                                        leading: Image.asset(
                                            "assets/images/citizen_frog.png",
                                            width: 32),
                                        title: Text(players[i].name),
                                        trailing: !state.wordsAssigned
                                            ? IconButton(
                                                icon: const Icon(
                                                    Icons.delete_outline),
                                                onPressed: () =>
                                                    cubit.removePlayer(
                                                        players[i].name),
                                              )
                                            : null,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Alt action bar — SafeArea ile piksel taşması yok
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (players.length >= state.maxPlayers &&
                              !state.wordsAssigned)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: _btnStyle(),
                                onPressed: () => _saveCurrentAsGroup(context),
                                icon: const Icon(Icons.save),
                                label: const Text('Gruplara kaydet'),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (players.length == state.maxPlayers &&
                                  !state.wordsAssigned)
                                Expanded(
                                  child: ElevatedButton(
                                    style: _btnStyle(),
                                    onPressed: cubit.assignWords,
                                    child: const Text("Harfleri Ata"),
                                  ),
                                ),
                              if (players.length == state.maxPlayers &&
                                  !state.wordsAssigned)
                                const SizedBox(width: 12),
                              if (state.wordsAssigned && !state.wordsShown)
                                Expanded(
                                  child: ElevatedButton(
                                    style: _btnStyle(),
                                    onPressed: () => _showRevealDialog(context),
                                    child: const Text("Kelimeyi Göster"),
                                  ),
                                ),
                              if (state.wordsAssigned && state.wordsShown)
                                Expanded(
                                  child: ElevatedButton(
                                    style: _btnStyle(),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const DiscussScreen()),
                                      );
                                    },
                                    child: const Text("Oyuna Başla"),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ButtonStyle _btnStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7ed6a3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        elevation: 1.5,
      );

  // --- Actions & Dialogs ---

  void _cancelCurrentSelection(BuildContext context) async {
    final playerCubit = context.read<PlayerCubit>();
    playerCubit.clearPlayers();
    playerCubit.resetWords();

    try {
      await context.read<GroupCubit>().clearLastUsed();
    } catch (_) {}

    _showSnack(context, 'Seçilen kullanıcılar iptal edildi.');
  }

  void _showAddNameDialog(BuildContext context) {
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
                _showSnack(context, 'İsim boş olamaz.');
                return;
              }
              final exists = state.players
                  .any((p) => p.name.toLowerCase() == text.toLowerCase());
              if (exists) {
                _showSnack(context, 'Bu isim zaten eklenmiş.');
                return;
              }
              if (state.players.length >= state.maxPlayers) {
                _showSnack(context,
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

  void _showSnack(BuildContext context, String message) {
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

  void _saveCurrentAsGroup(BuildContext context) async {
    final playerCubit = context.read<PlayerCubit>();
    final players = playerCubit.state.players.map((p) => p.name).toList();

    if (players.length < 3) {
      _showSnack(context, 'En az 3 oyuncu olmalı.');
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
                _showSnack(context, 'Grup adı boş olamaz.');
                return;
              }
              try {
                final groupCubit = context.read<GroupCubit>();
                await groupCubit.create(name, players);
                await groupCubit.setLastUsed(
                  groupCubit.state.groups.firstWhere((g) => g.name == name).id,
                );
                _showSnack(context, 'Grup kaydedildi.');
                Navigator.pop(context);
              } catch (_) {
                _showSnack(context, 'Grup kaydedildi. (fallback)');
                Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showRevealDialog(BuildContext context) {
    final cubit = context.read<PlayerCubit>();

    void openForIndex() {
      final s = cubit.state;
      final i = s.currentRevealIndex;
      if (i >= s.players.length) return;

      final player = s.players[i];
      final nextName =
          (i + 1 < s.players.length) ? s.players[i + 1].name : null;
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
                    style: _btnStyle(),
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
}
