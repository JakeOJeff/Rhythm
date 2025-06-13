# 🎵 Rhythm

**Rhythm** is a fast-paced, minimalist rhythm game built with [LÖVE 2D](https://love2d.org/), a game engine that uses Lua. The project explores core rhythm game mechanics—precise timing, beatmapping, and real-time player input—wrapped in a lightweight and easily modifiable prototype. This game is ideal for those interested in learning how rhythm-based systems work under the hood.

---

## 🎮 Gameplay Overview

In Rhythm, players must press keys in time with incoming notes. These notes fall down their respective lanes, and the player must hit the correct key at just the right moment. Timing is critical and determines whether a hit is scored as **Perfect**, **Good**, or **Missed**.

### Default Controls

| Key | Lane |
|-----|------|
| A   | Lane 1 |
| S   | Lane 2 |
| D   | Lane 3 |
| F   | Lane 4 |

Visual cues scroll down the screen in sync with the background music, guiding the player to time their inputs accurately.

---

## 🧠 Core Concepts & Design

Rhythm was built from the ground up to experiment with the fundamental logic behind rhythm games.

### 🔁 Beat Mapping System

- Notes are defined as Lua tables, where each entry contains a **timestamp** and **lane index**.
- Notes are triggered in-game by comparing their timestamp with the current audio playback time.
- This makes it easy to add custom tracks and levels by adjusting the timing data.

### 🧮 Scoring & Timing Precision

- Player inputs are checked against the nearest note's timestamp.
- The time delta is compared to a margin of error to classify it as **Perfect**, **Good**, or **Missed**.
- Combos and score multipliers can be added by chaining successful hits.

### 🎨 Rendering & Visuals

- All graphics are rendered using LÖVE’s built-in drawing functions (no external libraries).
- Note objects fall vertically over time to simulate movement.
- Minimalist aesthetic to focus on timing and gameplay clarity.

### 🔊 Audio Synchronization

- Uses `love.audio` and `love.timer` to match gameplay events with music in real-time.
- Accurate syncing is critical; LÖVE provides a consistent game loop for tight timing.

---

## 🛠️ Technologies Used

| Tool / Library | Purpose |
|----------------|---------|
| **LÖVE 2D**     | Game framework (Lua-based) |
| **Lua**         | Game logic, beatmaps, rendering |
| **love.audio**  | Background music playback |
| **love.graphics** | Drawing UI, lanes, notes |

---

## 🧪 Development Notes

- Designed to run at a fixed framerate to ensure consistent behavior across systems.
- Beatmap timing was manually aligned by ear and adjusted through testing.
- The game logic separates visual rendering from beatmap processing for clarity and modifiability.
- Focused on readability and extensibility for future upgrades.

---

## 💡 Future Ideas

- 🎼 Beatmap editor tool for custom song creation
- 📊 Post-game analytics (accuracy graphs, note hit/miss timeline)
- 🌈 Visual effects for combos and successful hits
- 🌐 Online leaderboard and song sharing
- 🎮 Gamepad support

---

## 👀 Preview

> *(You can add a screenshot or gameplay GIF here to showcase visuals and timing.)*

---

## 🙌 Credits

Built with ❤️ using [LÖVE 2D](https://love2d.org/)  
Created by [@JakeOJeff](https://github.com/JakeOJeff)

---
