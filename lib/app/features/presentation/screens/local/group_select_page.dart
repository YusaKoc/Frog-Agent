// lib/app/features/groups/presentation/pages/group_select_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog_agent/app/common/get_it/get_it.dart';
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_cubit.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/groups_state.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_cubit.dart';
import 'package:frog_agent/app/features/presentation/screens/local/player_setup_screen.dart';

class GroupSelectPage extends StatefulWidget {
  const GroupSelectPage({super.key});

  @override
  State<GroupSelectPage> createState() => _GroupSelectPageState();
}

class _GroupSelectPageState extends State<GroupSelectPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupCubit>(
      create: (_) => sl<GroupCubit>()..load(),
      child: Scaffold(
        // Üst kısım: degrade arkaplan ile bütünlük
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFc1fba4), Color(0xFF7ed6a3)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar benzeri üst şerit
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        'Gruplar',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2e7d5b),
                                ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Mevcut oyuncuları grup olarak kaydet',
                        icon: const Icon(Icons.save_alt),
                        onPressed: () => _saveCurrentAsGroup(context),
                      ),
                    ],
                  ),
                ),

                // Özet kart + son kullanılan rozet
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: BlocBuilder<GroupCubit, GroupState>(
                    builder: (context, gState) {
                      final lastId = context.read<GroupCubit>().getLastUsed();
                      final lastGroup = (lastId == null)
                          ? null
                          : gState.groups
                              .where((e) => e.id == lastId)
                              .cast<PlayerGroup?>()
                              .firstOrNull;
                      return Card(
                        color: const Color(0xFFfff5a5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Image.asset("assets/images/agent_frog.png",
                                  width: 44),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kayıtlı Grup Sayısı',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: const Color(0xFF4aa96c),
                                              fontWeight: FontWeight.w700,
                                            )),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${gState.groups.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF2e7d5b),
                                          ),
                                    ),
                                    if (lastGroup != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.history,
                                                size: 16,
                                                color: Colors.black54),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Son kullanılan: ${lastGroup.name}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Arama kutusu
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Grup ara',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                // Liste alanı
                Expanded(
                  child: BlocBuilder<GroupCubit, GroupState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final query = _searchCtrl.text.trim().toLowerCase();
                      final filtered = query.isEmpty
                          ? state.groups
                          : state.groups
                              .where(
                                  (g) => g.name.toLowerCase().contains(query))
                              .toList();

                      if (filtered.isEmpty) {
                        return _EmptyState(
                            onCreateTap: () => _createGroup(context));
                      }

                      return RefreshIndicator(
                        onRefresh: () async =>
                            context.read<GroupCubit>().load(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final g = filtered[i];
                            return Dismissible(
                              key: ValueKey(g.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) => _confirmDelete(context, g),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: _GroupCard(
                                group: g,
                                onQuickStart: () => _quickStart(context, g),
                                onEdit: () => _editGroup(context, g),
                                onDelete: () async {
                                  final ok = await _confirmDelete(context, g);
                                  if (ok == true)
                                    context.read<GroupCubit>().delete(g.id);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF7ed6a3),
          foregroundColor: Colors.white,
          onPressed: () => _createGroup(context),
          icon: const Icon(Icons.add),
          label: const Text('Yeni Grup'),
        ),
      ),
    );
  }

  // ---- Widgets & Dialogs ----

  Future<bool?> _confirmDelete(BuildContext context, PlayerGroup g) async {
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

  void _quickStart(BuildContext context, PlayerGroup g) {
    final playerCubit = context.read<PlayerCubit>();
    playerCubit.setPlayers(g.players);
    playerCubit.assignWords();
    context.read<GroupCubit>().setLastUsed(g.id);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
    );
  }

  void _createGroup(BuildContext context) {
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
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editGroup(BuildContext context, PlayerGroup g) {
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
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Güncelle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCurrentAsGroup(BuildContext context) {
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
}

// --- Kart bileşeni ---
class _GroupCard extends StatelessWidget {
  const _GroupCard({
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

// --- Boş durum ---
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/agent_frog.png", width: 120),
            const SizedBox(height: 12),
            Text(
              'Henüz grup yok',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Oyuncu listelerini gruplar olarak kaydet; sonra tek dokunuşla oyunu başlat.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Yeni Grup Oluştur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ed6a3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// küçük extension: firstOrNull
extension _IterableX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
