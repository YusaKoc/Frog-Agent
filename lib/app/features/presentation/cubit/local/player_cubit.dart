// lib/app/features/players/presentation/cubit/player_cubit.dart
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:frog_agent/app/features/data/local/entity/player_entity.dart';
import 'package:frog_agent/app/features/data/local/models/words.dart';
import 'package:frog_agent/app/features/presentation/cubit/local/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState());

  // ---- Setup ----
  void setMaxPlayers(int count) {
    emit(state.copyWith(maxPlayers: count, players: const []));
  }

  void resetWords() {
    final resetPlayers = [
      for (final p in state.players) p.copyWith(word: '', isEliminated: false)
    ];

    emit(state.copyWith(
      players: resetPlayers,
      disguisedIndex: -1,
      selectedPair: const [],
      speakingOrder: const [], // konuşma sırası tekrar üretilecek
      wordsAssigned: false, // kelimeler artık atanmış değil
      wordsShown: false, // gösterim akışı başa sar
      currentRevealIndex: 0, // ilk oyuncudan başlanır
    ));
  }

  void setPlayers(List<String> names) {
    emit(state.copyWith(
      players: names.map((e) => Player(name: e, word: '')).toList(),
      disguisedIndex: -1,
      selectedPair: const [],
      speakingOrder: const [],
      wordsAssigned: false,
      wordsShown: false,
      currentRevealIndex: 0,
    ));
  }

  void clearPlayers() {
    emit(state.copyWith(players: const []));
  }

  void addPlayer(String name) {
    if (state.players.length >= state.maxPlayers) return;
    emit(state
        .copyWith(players: [...state.players, Player(name: name, word: '')]));
  }

  void removePlayer(String name) {
    emit(state.copyWith(
      players: state.players.where((p) => p.name != name).toList(),
    ));
  }

  // ---- Game Logic ----
  void assignWords() {
    if (state.players.isEmpty) return;
    final random = Random();

    final pair = wordPairs[random.nextInt(wordPairs.length)];
    final commonWord = pair[0];
    final disguisedWord = pair[1];

    final disguisedIndex = random.nextInt(state.players.length);

    final updatedPlayers = [
      for (int i = 0; i < state.players.length; i++)
        state.players[i].copyWith(
          word: i == disguisedIndex ? disguisedWord : commonWord,
        )
    ];

    emit(state.copyWith(
      players: updatedPlayers,
      disguisedIndex: disguisedIndex,
      selectedPair: [commonWord, disguisedWord],
      wordsAssigned: true,
      wordsShown: false,
      currentRevealIndex: 0,
    ));
  }

  void eliminatePlayer(String name) {
    final updated = state.players
        .map((p) => p.name == name ? p.copyWith(isEliminated: true) : p)
        .toList();
    emit(state.copyWith(players: updated));
  }

  bool isDisguised(String name) {
    if (state.disguisedIndex < 0 ||
        state.disguisedIndex >= state.players.length) return false;
    return state.players[state.disguisedIndex].name == name;
  }

  bool checkWinCondition() => state.activePlayers.length <= 2;

  void generateSpeakingOrderOnce() {
    if (state.speakingOrder.isEmpty) {
      final shuffled = [...state.players.map((p) => p.name)]..shuffle();
      emit(state.copyWith(speakingOrder: shuffled));
    }
  }

  // ---- Reveal flow (kelime gösterimi) ----
  void nextReveal() {
    final next = state.currentRevealIndex + 1;
    if (next >= state.players.length) {
      emit(state.copyWith(
          wordsShown: true, currentRevealIndex: state.players.length));
    } else {
      emit(state.copyWith(currentRevealIndex: next));
    }
  }

  void resetReveals() {
    emit(state.copyWith(currentRevealIndex: 0, wordsShown: false));
  }

  void resetGame() {
    emit(const PlayerState());
  }
}
