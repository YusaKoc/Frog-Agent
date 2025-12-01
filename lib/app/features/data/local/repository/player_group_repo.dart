// lib/app/features/groups/data/repositories/group_repository.dart
import 'package:frog_agent/app/features/data/local/models/player_groups.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class GroupRepository {
  final Box<PlayerGroup> groupsBox;
  final Box<String> prefsBox;
  GroupRepository(this.groupsBox, this.prefsBox);

  static const _lastGroupKey = 'last_group_id';

  List<PlayerGroup> getAll() {
    final items = groupsBox.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<PlayerGroup> create(String name, List<String> players) async {
    final id = const Uuid().v4();
    final group = PlayerGroup(
      id: id,
      name: name.trim(),
      players: players,
      createdAt: DateTime.now(),
    );
    await groupsBox.put(id, group);
    return group;
  }

  Future<void> update(PlayerGroup group) async {
    await groupsBox.put(group.id, group);
  }

  Future<void> delete(String id) async {
    await groupsBox.delete(id);
  }

  PlayerGroup? getById(String id) => groupsBox.get(id);

  Future<void> saveLastGroupId(String id) async =>
      prefsBox.put(_lastGroupKey, id);
  String? getLastGroupId() => prefsBox.get(_lastGroupKey);

  // ✅ YENİ: son seçili grubu temizle
  Future<void> clearLastGroupId() async => prefsBox.delete(_lastGroupKey);
}
