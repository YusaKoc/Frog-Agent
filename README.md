# Frog Agent

A fun, secret-word party game built with Flutter. Designed for 3–12 players on a single device. One player is secretly the "Disguised Frog" with a different word than the others. Players describe their words and vote to eliminate the suspicious one!

---

## How to Run the App

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YusaKoc/Frog-Agent.git
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

> You can run it on an emulator or a physical device (Android or iOS).

---

## Project Structure

```
lib/
├── main.dart                   # App entry point
├── models/
│   ├── player.dart             # Player model (name, word, eliminated)
│   └── words.dart              # Predefined word pairs (common & disguised)
├── providers/
│   └── player_provider.dart    # Game logic using Riverpod (state, roles, eliminations)
├── screens/
│   ├── player_setup_screen.dart # Set player count, enter names, assign words
│   ├── discuss_screen.dart      # Players see discussion order & rules
│   └── voting_screen.dart       # Vote to eliminate one player each round
├── assets/
│   └── images/                 # Frog character illustrations (citizen & agent)
```

---

## Game Flow

1. Choose number of players (3–12).
2. Players enter their names and pass the device around to view their secret words.
3. One player (Disguised) sees a different word.
4. Players take turns describing their word — without saying it.
5. Vote to eliminate a suspicious player.
6. Game ends when:
    - Disguised is eliminated → **Citizens Win**
    - Only 2 players remain (1 citizen, 1 disguised) → **Disguised Wins**

---

## Built With

- [Flutter](https://flutter.dev)
- [Flutter Riverpod](https://riverpod.dev) for state management
