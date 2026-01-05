import 'package:flutter/material.dart';
import 'package:frog_agent/app/common/asset_paths/asset_paths.dart';
import 'package:frog_agent/app/features/data/local/entity/player_entity.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    super.key,
    required this.players,
    required this.wordsAssigned,
    required this.onRemovePlayer,
  });

  final List<Player> players;
  final bool wordsAssigned;
  final ValueChanged<String> onRemovePlayer;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
      sliver: SliverToBoxAdapter(
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: players.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Image.asset(
                          AssetPaths.citizenFrog,
                          width: 72,
                        ),
                        const SizedBox(height: 8),
                        const Text("Henüz oyuncu yok"),
                        const SizedBox(height: 4),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: players.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      leading: Image.asset(
                        "assets/images/citizen_frog.png",
                        width: 32,
                      ),
                      title: Text(players[i].name),
                      trailing: !wordsAssigned
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => onRemovePlayer(players[i].name),
                            )
                          : null,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
