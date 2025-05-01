import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../models/words.dart';

class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier() : super([]);

  int disguisedIndex = -1;
  List<String> selectedPair = [];

  void setPlayers(List<String> names) {
    state = names.map((name) => Player(name: name, word: '')).toList();
  }

  void clearPlayers() => state = [];

  void assignWords() {
    if (state.isEmpty) return;
    final random = Random();

    selectedPair = wordPairs[random.nextInt(wordPairs.length)];
    final commonWord = selectedPair[0];
    final disguisedWord = selectedPair[1];

    disguisedIndex = random.nextInt(state.length);

    state = [
      for (int i = 0; i < state.length; i++)
        Player(
          name: state[i].name,
          word: i == disguisedIndex ? disguisedWord : commonWord,
        ),
    ];
  }

  void addPlayer(String name) {
    state = [...state, Player(name: name, word: '')];
  }

  void removePlayer(String name) {
    state = state.where((player) => player.name != name).toList();
  }

  void eliminatePlayer(String name) {
    state = [
      for (final p in state)
        if (p.name == name) Player(name: p.name, word: p.word, isEliminated: true) else p
    ];
  }

  List<Player> get activePlayers => state.where((p) => !p.isEliminated).toList();

  bool isDisguised(String name) => state[disguisedIndex].name == name;

  bool checkWinCondition() => activePlayers.length <= 2;

  String get commonWord => selectedPair[0];
  String get disguisedWord => selectedPair[1];



  List<String> speakingOrder = [];

  void generateSpeakingOrder() {
    if (speakingOrder.isEmpty) {
      final shuffled = [...state.map((p) => p.name)]..shuffle();
      speakingOrder = shuffled;
    }
  }

  List<String> get getSpeakingOrder => speakingOrder;

  void resetGame() {
    disguisedIndex = -1;
    selectedPair = [];
    speakingOrder = [];
    state = [];
  }

}

final playerProvider = StateNotifierProvider<PlayerNotifier, List<Player>>((ref) {
  return PlayerNotifier();
});
