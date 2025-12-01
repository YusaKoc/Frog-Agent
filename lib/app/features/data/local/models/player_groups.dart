// lib/app/features/groups/data/models/player_group.dart

import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';

part 'player_groups.g.dart';

@HiveType(typeId: 10) // benzersiz olmalı
class PlayerGroup extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> players;

  @HiveField(3)
  DateTime createdAt;

  PlayerGroup({
    required this.id,
    required this.name,
    required this.players,
    required this.createdAt,
  });

  PlayerGroup copyWith({
    String? id,
    String? name,
    List<String>? players,
    DateTime? createdAt,
  }) {
    return PlayerGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
