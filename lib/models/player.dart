enum Role { disguised, citizen }

class Player {
  final String name;
  final String? word;
  bool isEliminated;

  Player({
    required this.name,
    required this.word,
    this.isEliminated = false,
  });
}
