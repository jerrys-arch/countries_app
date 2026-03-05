# Countries App 🌍

A sleek, high-performance Flutter application built for the A2SV coding challenge. This app allows users to explore countries across the globe using the REST Countries API, featuring smooth transitions, local data persistence, and a clean, maintainable architecture.

## 🚀 Features
- **Dynamic Country List:** Browse countries with real-time search and filtering.
- **Detailed Insights:** Comprehensive data including population, region, capital, and timezones.
- **Favorites System:** Save favorite countries locally for quick access.
- **Theme Support:** Full Dark and Light mode compatibility.
- **Performance:** Optimized with shimmer loading effects, search debouncing, and image caching.
- **Responsive Design:** Adaptive UI switching between List and Grid views for Mobile and Tablet/Web.

---

## 🏗️ Architecture & Technology Choices

### 1. Clean Architecture
The project follows a layered architecture to ensure separation of concerns:
- **Models (Domain):** Unified data entities using `Equatable` for efficient state comparison.
- **Repositories (Data):** Handles API logic and data transformation.
- **Cubits (Logic):** Manages state using the BLoC pattern for predictable UI updates.
- **Presentation (UI):** Modular widgets and screens for a responsive user experience.



### 2. State Management: Cubit
I chose **Cubit** (from the `flutter_bloc` package) because it provides a reactive approach with less boilerplate than full Blocs, ensuring the UI remains "dumb" and strictly reflects the state emitted by the logic layer.

### 3. Dependency Injection: Get_It
The `get_it` service locator provides a single instance of the `CountryRepository` and other services, making the app easier to test and reducing manual constructor injection.

### 4. Local Persistence: Shared Preferences
I used `shared_preferences` to persist the "Favorites" list. This ensures user data remains available even after the app is closed or restarted.

### 5. Performance Optimization: Debounce Logic
The search functionality implements **Debounce logic** using a `Timer`. This prevents the app from firing an API request for every single keystroke, significantly reducing network traffic.



### 6. Data Fetching & Offline Support
- **Pull-to-Refresh:** Integrated the `RefreshIndicator` on the Home screen for manual API re-fetching.
- **Offline Viewing:** Enabled offline access for previously visited content:
    - **Flag Caching:** Using `CachedNetworkImage`, all country flags are stored on the local disk once viewed.
    - **Persistent Favorites:** Favorited countries are always accessible via Shared Preferences.
    - **State Persistence:** Using the Repository pattern, fetched data remains available for viewing during the session even if connection is lost.

### 7. Responsive UI (Adaptive Layout)
The app uses `LayoutBuilder` to provide a premium experience across all device sizes:
- **Mobile:** A clean `ListView` optimized for vertical scrolling.
- **Tablet/Web:** Switches to a `GridView` with a multi-column layout for large-screen efficiency.



### 8. Dynamic Sorting Logic
Implemented custom sorting within the `CountryCubit`:
- **Multi-Criteria:** Toggle between sorting by **Name (Alphabetical)** or **Population (Numerical)**.
- **Performance:** Sorting is performed on the locally cached list in memory for instant feedback.
  
## 🛠️ Setup and Installation

### Prerequisites
- Flutter SDK: `^3.35.6`
- Dart SDK: `^3.9.2`

### Installation Steps

1. Clone the repository:
   ```bash
   git clone [https://github.com/jerrys-arch/countries_app.git]

2 Navigate to the project directory:

   cd countries_app
   
3 Install dependencies:

   flutter pub get
   
4 Run the application:

   flutter run

Environment Variables & Theming
Environment Variables: No API keys or .env files are required. This app uses the public REST Countries API.

Theming: The app automatically detects system theme settings. You can toggle between Light and Dark mode via your device settings to see the full UI adaptation.   

