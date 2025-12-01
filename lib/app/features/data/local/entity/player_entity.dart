// lib/app/features/players/domain/entities/player.dart
import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String name;
  final String? word;
  final bool isEliminated;

  const Player({
    required this.name,
    required this.word,
    this.isEliminated = false,
  });

  Player copyWith({
    String? name,
    String? word,
    bool? isEliminated,
  }) {
    return Player(
      name: name ?? this.name,
      word: word ?? this.word,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }

  @override
  List<Object?> get props => [name, word, isEliminated];
}
