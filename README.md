# Countries App 🌍

A sleek, high-performance Flutter application built for the A2SV coding challenge. This app allows users to explore countries across the globe using the REST Countries API, featuring smooth transitions, local data persistence, and a clean, maintainable architecture.

## 🚀 Features
- **Dynamic Country List:** Browse countries with real-time search and filtering.
- **Detailed Insights:** Comprehensive data including population, region, capital, and timezones.
- **Hero Animations:** Smooth visual transitions of flags between screens.
- **Favorites System:** Save favorite countries locally for quick access.
- **Theme Support:** Full Dark and Light mode compatibility.
- **Performance:** Optimized with shimmer loading effects and image caching.

---

## 🏗️ Architecture & Technology Choices

### 1. Clean Architecture
The project follows a layered architecture to ensure separation of concerns:
- **Models (Domain):** Unified data entities using `Equatable` for efficient state comparison.
- **Repositories (Data):** Handles API logic and data transformation.
- **Cubits (Logic):** Manages state using the BLoC pattern for predictable UI updates.
- **Presentation (UI):** Modular widgets and screens for a responsive user experience.

### 2. State Management: Cubit
I chose **Cubit** (from the `flutter_bloc` package) because:
- It provides a **reactive** approach with less boilerplate than full Blocs.
- It ensures the UI remains "dumb," strictly reflecting the current state emitted by the logic layer.
- It simplifies handling complex states like Loading, Loaded, and Error.

### 3. Dependency Injection: Get_It
The `get_it` service locator is used to provide a single instance of the `CountryRepository` and other services, making the app easier to test and reducing manual constructor injection.

### 4. Key Libraries
- **CachedNetworkImage:** For high-performance image loading and disk caching.
- **Equatable:** To optimize rebuilds by comparing object values instead of memory references.
- **HTTP:** For reliable communication with the REST Countries API.

---

## 🛠️ Setup and Installation

### Prerequisites
- Flutter SDK: `^3.0.0`
- Dart SDK: `^3.0.0`

### Installation Steps

1. Clone the repository:
   ```bash
   git clone [https://github.com/jerrys-arch/countries_app.git](https://github.com/jerrys-arch/countries_app.git)

2 Navigate to the project directory:

   cd countries_app
   
3 Install dependencies:

   flutter pub get
   
4 Run the application:

   flutter run

Environment Variables & Theming
Environment Variables: No API keys or .env files are required. This app uses the public REST Countries API.

Theming: The app automatically detects system theme settings. You can toggle between Light and Dark mode via your device settings to see the full UI adaptation.   

