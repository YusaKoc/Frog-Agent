import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_agent/screens/discuss_screen.dart';
import '../providers/player_provider.dart';

class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  int playerCount = 3;
  int currentPlayerIndex = 0;
  bool wordsAssigned = false;
  bool wordsShown = false;

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFc1fba4),
              Color(0xFF7ed6a3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                children: [
                  Text("FROG AGENT", style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),),
                  Image.asset("assets/images/agent_frog.png", width: 250,),
                ],
              ),
              if (!wordsAssigned) ...[
                DropdownButton<int>(
                  value: playerCount,
                  items: List.generate(10, (index) => index + 3)
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text("$e Frogs 🐸")))
                      .toList(),
                  onChanged: (value) {
                    setState(() => playerCount = value!);
                    ref.read(playerProvider.notifier).clearPlayers();
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFffe0e9),
                          hintText: 'Enter player name',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'Frog Name',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7ed6a3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius
                            .circular(16)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        elevation: 4,
                      ),
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            players.length < playerCount) {
                          ref.read(playerProvider.notifier).addPlayer(
                              _nameController.text);
                          _nameController.clear();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) =>
                      ListTile(
                        leading: Image.asset("assets/images/citizen_frog.png"),
                        title: Text(players[index].name),
                        trailing: !wordsAssigned
                            ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              ref.read(playerProvider.notifier)
                                  .removePlayer(players[index].name),
                        )
                            : null,
                      ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Remember, the secret word that will be revealed first belongs to the person at the top of the list.",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (players.length == playerCount && !wordsAssigned)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed6a3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    elevation: 4,
                  ),
                  onPressed: () {
                    ref.read(playerProvider.notifier).assignWords();
                    setState(() => wordsAssigned = true);
                  },
                  child: const Text("Assign Words"),
                ),
              if (wordsAssigned && !wordsShown)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed6a3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    elevation: 4,
                  ),
                  onPressed: () {
                    _showNextWord(players);
                  },
                  child: const Text("Show Words"),
                ),
              if (wordsShown)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7ed6a3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const DiscussScreen()));
                  },
                  child: const Text("Start Game"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNextWord(List players) {
    if (currentPlayerIndex >= players.length) {
      setState(() => wordsShown = true);
      return;
    }

    final player = players[currentPlayerIndex];
    final nextPlayerName = currentPlayerIndex + 1 < players.length
        ? players[currentPlayerIndex + 1].name
        : null;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        bool showWord = false;

        return StatefulBuilder(
          builder: (context, setState) =>
              AlertDialog(
                backgroundColor: const Color(0xFFfff5a5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text("${player.name}'s Turn"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!showWord)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7ed6a3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          elevation: 4,
                        ),
                        onPressed: () => setState(() => showWord = true),
                        child: const Text("Show My Word"),
                      ),
                    if (showWord) ...[
                      const SizedBox(height: 10),
                      Text(
                        player.word,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (nextPlayerName != null)
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              const TextSpan(text: "Next shows "),
                              TextSpan(
                                text: nextPlayerName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: "'s word"),
                            ],
                          ),
                        ),
                      if (nextPlayerName == null)
                        const Text("This was the last player's word."),
                    ],
                  ],
                ),
                actions: [
                  if (showWord)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => currentPlayerIndex++);
                        _showNextWord(players);
                      },
                      child: const Text("Next"),
                    ),
                ],
              ),
        );
      },
    );
  }
}

