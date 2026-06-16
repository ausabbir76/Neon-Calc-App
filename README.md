# 🚀 Neon Calc: A Visual & Immersive Calculator Experience

Neon Calc is a visually stunning, high-performance calculator application built with Flutter. It blends advanced mathematical capabilities with an immersive, theme-driven UI that brings your calculations to life through glowing effects, glassmorphism, and dynamic animations.

Whether you're a student, professional, or enthusiast, Neon Calc offers a unique environment where functionality meets cutting-edge design.

---

## ✨ Key Features

- **🧮 Advanced Expression Engine**: Evaluate complex mathematical expressions using a robust Shunting-yard algorithm. Supports operators, constants (π, e), and advanced functions.
- **🧪 Scientific & Basic Modes**: Seamlessly toggle between a streamlined basic layout and a powerful scientific panel with shift-key functionality.
- **🎨 Immersive Theming**: Choose from multiple premium themes, each with its own unique visual identity:
    - **Neon & Cyber**: High-contrast, glowing aesthetics for the futuristic soul.
    - **Glass & Amber Glass**: Elegant glassmorphism with soft transparency.
    - **Retro & Synthwave**: Nostalgic 8-bit and 80s-inspired environments.
- **🔊 Multi-Sensory Feedback**: Every interaction is accompanied by theme-specific sound effects, from satisfying mechanical clicks to futuristic synth tones.
- **📜 Calculation History**: Keep track of your work with a dedicated history screen. Review, reuse, or manage past calculations with ease.
- **🧠 Intelligent Memory**: Full support for memory operations (MC, MR, M+, M-) to handle complex multi-step calculations.
- **✨ Visual Effects**: Enjoy a dynamic experience with glow effects, button flashes, and responsive UI animations that make every tap feel alive.
- **📱 Responsive & Precise**: Optimized for all screen sizes with a custom-built key panel and high-precision display.

---

## 🎭 Theme Gallery

Experience Neon Calc in various aesthetics. Each theme transforms the entire UI, including typography, backgrounds, and interactive elements.

### 🌈 Neon Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Neon Theme/neon (1).png" width="250"> | <img src="screenshoots/Neon Theme/neon (2).png" width="250"> | <img src="screenshoots/Neon Theme/neon (3).png" width="250"> |
| <img src="screenshoots/Neon Theme/neon (4).png" width="250"> | <img src="screenshoots/Neon Theme/neon (5).png" width="250"> | <img src="screenshoots/Neon Theme/neon (6).png" width="250"> |

### 🏙️ Cyber Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Cyber Theme/cyber (1).png" width="250"> | <img src="screenshoots/Cyber Theme/cyber (2).png" width="250"> | <img src="screenshoots/Cyber Theme/cyber (3).png" width="250"> |
| <img src="screenshoots/Cyber Theme/cyber (4).png" width="250"> | <img src="screenshoots/Cyber Theme/cyber (5).png" width="250"> | <img src="screenshoots/Cyber Theme/cyber (6).png" width="250"> |

### 🧪 Glass Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Glass Theme/amber (1).png" width="250"> | <img src="screenshoots/Glass Theme/amber (2).png" width="250"> | <img src="screenshoots/Glass Theme/amber (3).png" width="250"> |
| <img src="screenshoots/Glass Theme/amber (4).png" width="250"> | <img src="screenshoots/Glass Theme/amber (5).png" width="250"> | <img src="screenshoots/Glass Theme/amber (6).png" width="250"> |

### 🍯 Amber Glass Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Amber Glass Theme/amber_glass (1).png" width="250"> | <img src="screenshoots/Amber Glass Theme/amber_glass (2).png" width="250"> | <img src="screenshoots/Amber Glass Theme/amber_glass (3).png" width="250"> |
| <img src="screenshoots/Amber Glass Theme/amber_glass (4).png" width="250"> | <img src="screenshoots/Amber Glass Theme/amber_glass (5).png" width="250"> | <img src="screenshoots/Amber Glass Theme/amber_glass (6).png" width="250"> |

### 📺 Retro Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Retro Theme/retro (1).png" width="250"> | <img src="screenshoots/Retro Theme/retro (2).png" width="250"> | <img src="screenshoots/Retro Theme/retro (3).png" width="250"> |
| <img src="screenshoots/Retro Theme/retro (4).png" width="250"> | <img src="screenshoots/Retro Theme/retro (5).png" width="250"> | <img src="screenshoots/Retro Theme/retro (6).png" width="250"> |

### 🌌 Synthwave Theme
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Synthwave Theme/synthwave (1).png" width="250"> | <img src="screenshoots/Synthwave Theme/synthwave (2).png" width="250"> | <img src="screenshoots/Synthwave Theme/synthwave (3).png" width="250"> |
| <img src="screenshoots/Synthwave Theme/synthwave (4).png" width="250"> | <img src="screenshoots/Synthwave Theme/synthwave (5).png" width="250"> | <img src="screenshoots/Synthwave Theme/synthwave (6).png" width="250"> |

### 🟠 Orange Dark
| | | |
| :---: | :---: | :---: |
| <img src="screenshoots/Orange Dark/orange_dark (1).png" width="250"> | <img src="screenshoots/Orange Dark/orange_dark (2).png" width="250"> | <img src="screenshoots/Orange Dark/orange_dark (3).png" width="250"> |
| <img src="screenshoots/Orange Dark/orange_dark (4).png" width="250"> | <img src="screenshoots/Orange Dark/orange_dark (5).png" width="250"> | <img src="screenshoots/Orange Dark/orange_dark (6).png" width="250"> |

---

## 🛠️ Technical Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **Expression Parsing**: Custom [Shunting-yard](https://en.wikipedia.org/wiki/Shunting-yard_algorithm) implementation
- **Database**: [SQLite](https://www.sqlite.org/) (via `sqflite`) for History management
- **Audio**: `audioplayers` for immersive sound effects
- **Persistence**: `shared_preferences` for theme and settings
- **Architecture**: Domain-Driven Design (DDD) with a clean Feature-based structure

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / VS Code with Flutter extension

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/neon_calc.git
   ```
2. Navigate to the project directory:
   ```bash
   cd neon_calc
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Created with ❤️ by AU Sabbir*
