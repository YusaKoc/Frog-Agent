// lib/app/features/players/presentation/cubit/player_state.dart
import 'package:equatable/equatable.dart';
import 'package:frog_agent/app/features/data/local/entity/player_entity.dart';

class PlayerState extends Equatable {
  final List<Player> players;
  final int disguisedIndex; // -1 => atanmamış
  final List<String> selectedPair; // [common, disguised] ya da []
  final List<String> speakingOrder; // sabit sıra
  final int maxPlayers; // dropdown seçimi
  final bool wordsAssigned; // kelimeler atandı mı
  final bool wordsShown; // tüm kelimeler gösterildi mi
  final int currentRevealIndex; // sıradaki oyuncu (kelime gösterimi)

  const PlayerState({
    this.players = const [],
    this.disguisedIndex = -1,
    this.selectedPair = const [],
    this.speakingOrder = const [],
    this.maxPlayers = 3,
    this.wordsAssigned = false,
    this.wordsShown = false,
    this.currentRevealIndex = 0,
  });

  List<Player> get activePlayers =>
      players.where((p) => !p.isEliminated).toList();

  String? get commonWord => selectedPair.isNotEmpty ? selectedPair[0] : null;
  String? get disguisedWord => selectedPair.isNotEmpty ? selectedPair[1] : null;

  bool get hasWordsAssigned =>
      disguisedIndex != -1 && selectedPair.length == 2 && wordsAssigned;

  PlayerState copyWith({
    List<Player>? players,
    int? disguisedIndex,
    List<String>? selectedPair,
    List<String>? speakingOrder,
    int? maxPlayers,
    bool? wordsAssigned,
    bool? wordsShown,
    int? currentRevealIndex,
  }) {
    return PlayerState(
      players: players ?? this.players,
      disguisedIndex: disguisedIndex ?? this.disguisedIndex,
      selectedPair: selectedPair ?? this.selectedPair,
      speakingOrder: speakingOrder ?? this.speakingOrder,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      wordsAssigned: wordsAssigned ?? this.wordsAssigned,
      wordsShown: wordsShown ?? this.wordsShown,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
    );
  }

  @override
  List<Object?> get props => [
        players,
        disguisedIndex,
        selectedPair,
        speakingOrder,
        maxPlayers,
        wordsAssigned,
        wordsShown,
        currentRevealIndex,
      ];
}
