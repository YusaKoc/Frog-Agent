// lib/app/features/players/presentation/pages/voting_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/local/player_cubit.dart';
import '../../cubit/local/player_state.dart';
import 'player_setup_screen.dart';
import 'discuss_screen.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Üst bilgi kartı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: const Color(0xFFfff5a5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/agent_frog.png",
                          width: math.min(
                              MediaQuery.of(context).size.width * 0.12, 56),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Eleme Zamanı",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: const Color(0xFF4aa96c),
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Şüpheli oyuncuyu seç ve elenmesini onayla.",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Oyuncu listesi
              Expanded(
                child: BlocBuilder<PlayerCubit, PlayerState>(
                  builder: (context, state) {
                    final players = state.activePlayers;

                    if (players.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/images/citizen_frog.png",
                                  width: 90),
                              const SizedBox(height: 12),
                              Text(
                                "Aktif oyuncu kalmadı.",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2e7d5b),
                                    ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Yeni bir eleme yapmak için yeterli oyuncu yok.",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7ed6a3),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const DiscussScreen()),
                                    (r) => false,
                                  );
                                },
                                child: const Text("Geri Dön"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final p = players[i];
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFc1fba4),
                              child: Text(
                                p.name.characters.first.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF2e7d5b),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              p.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            subtitle: const Text("Aday"),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B6B),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                              ),
                              onPressed: () => _votePlayer(context, p.name),
                              child: const Text("Ele"),
                            ),
                            onTap: () => _votePlayer(context, p.name),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Alt kısa bilgi ve güvenli boşluk
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  "Karar vermeden önce kısa bir tartışma iyi gelebilir 🐸",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withOpacity(0.65),
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _votePlayer(BuildContext context, String playerName) {
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
                _showGameOverDialog(
                    context, "🎉 Köylü kurbağalar kazandı!", cubit);
              } else if (cubit.checkWinCondition()) {
                _showGameOverDialog(
                    context, "😈 Gizlenmiş kurbağa kazandı!", cubit);
              } else {
                _showCitizenEliminatedDialog(context, playerName);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showCitizenEliminatedDialog(BuildContext context, String playerName) {
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

  void _showGameOverDialog(
      BuildContext context, String title, PlayerCubit cubit) {
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
}
