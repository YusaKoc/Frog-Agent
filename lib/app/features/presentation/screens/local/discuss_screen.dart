import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/features/presentation/screens/local/voting_screen.dart';
import '../../cubit/local/player_cubit.dart';
import '../../cubit/local/player_state.dart';
import 'dart:math' as math;

class DiscussScreen extends StatelessWidget {
  const DiscussScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // build içinde doğrudan state değiştirmemek için post-frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PlayerCubit>();
      cubit.generateSpeakingOrderOnce();
    });

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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/agent_frog.png",
                            width: math.min(
                                MediaQuery.of(context).size.width * 0.12, 56)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tartışma Zamanı",
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
                                "Gizli kelimenizi belirtilen sırayla yalnızca bir kelime veya kısa bir ifade ile anlatın.",
                                textAlign: TextAlign.start,
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

              // Konuşma sırası listesi
              Expanded(
                child: BlocBuilder<PlayerCubit, PlayerState>(
                  builder: (context, state) {
                    final order = state.speakingOrder;

                    if (order.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/citizen_frog.png",
                                width: 80),
                            const SizedBox(height: 10),
                            Text(
                              "Konuşma sırası hazırlanıyor...",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2e7d5b),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                          16, 4, 16, 140), // alt buton için boşluk
                      itemCount: order.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final name = order[index];
                        final isFirst =
                            index == 0; // ilk konuşacak kişi rozetli
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFFc1fba4),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Color(0xFF2e7d5b),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -8,
                                  bottom: -8,
                                  child: Image.asset(
                                    "assets/images/citizen_frog.png",
                                    width: 26,
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            subtitle: isFirst
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.record_voice_over,
                                            size: 16, color: Colors.black54),
                                        SizedBox(width: 6),
                                        Text("Sıradaki konuşmacı"),
                                      ],
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Alt eylem çubuğu (sabit)
              _BottomActionBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7ed6a3),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            elevation: 1.5,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VotingScreen()),
            );
          },
          icon: const Icon(Icons.how_to_vote),
          label: const Text("Eleme Turuna Geç"),
        ),
      ),
    );
  }
}
