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

- ---![agent_frog1](https://github.com/user-attachments/assets/68e5ec2d-f790-4cb3-af25-2b075a732262)
![agent_frog2](https://github.com/user-attachments/assets/d9190c65-2381-46d3-94a2-b6f3b1f1308d)
![agent_frog3](https://github.com/user-attachments/assets/a3054901-30d4-45e0-977d-1068bb46f10e)
![agent_frog4](https://github.com/user-attachments/assets/baf55f1b-6426-4222-91f6-b600a2638e10)
![agent_frog5](https://github.com/user-attachments/assets/e80e5830-5b58-4a5f-8adc-5eee96af66cb)
![agent_frog6](https://github.com/user-attachments/assets/e8190197-590b-4c24-b25d-fb956ae5a147)
![agent_frog7](https://github.com/user-attachments/assets/7a2ce3ad-4802-4408-95a0-b7f4c0fdb94f)
![agent_frog8](https://github.com/user-attachments/assets/9ec0f81e-4e81-4a6f-8a05-0c5ebf032162)
![agent_frog9](https://github.com/user-attachments/assets/bd17487b-d4b7-4ecd-bfe9-3617086e63f5)
![agent_frog10](https://github.com/user-attachments/assets/5a893e10-fd14-495d-8595-949b402c714b)
![agent_frog11](https://github.com/user-attachments/assets/84d6276d-34c2-4588-8a50-56461131d357)
![agent_frog12](https://github.com/user-attachments/assets/7cde0281-a3e3-47f3-9fec-c365b6b3cfe5)
