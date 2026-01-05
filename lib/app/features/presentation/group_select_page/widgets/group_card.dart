// --- Kart bileşeni ---
import 'package:flutter/material.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    required this.onQuickStart,
    required this.onEdit,
    required this.onDelete,
  });

  final PlayerGroup group;
  final VoidCallback onQuickStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFc1fba4),
          child: Text(
            group.name.isNotEmpty
                ? group.name.characters.first.toUpperCase()
                : 'G',
            style: const TextStyle(
                color: Color(0xFF2e7d5b), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text('${group.players.length} oyuncu'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'start') onQuickStart();
            if (v == 'edit') onEdit();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
                value: 'start',
                child: ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text('Hızlı Başlat'))),
            PopupMenuItem(
                value: 'edit',
                child: ListTile(
                    leading: Icon(Icons.edit), title: Text('Düzenle'))),
            PopupMenuItem(
                value: 'delete',
                child:
                    ListTile(leading: Icon(Icons.delete), title: Text('Sil'))),
          ],
        ),
        onTap: onQuickStart,
      ),
    );
  }
}
