import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  static const String _storageKey = 'favorite_countries';
  final SharedPreferences _prefs;

  FavoritesCubit(this._prefs) : super(const FavoritesState()) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<String>? saved = _prefs.getStringList(_storageKey);
    if (saved != null) {
      emit(FavoritesState(favoriteCca2Codes: saved.toSet()));
    }
  }

  Future<void> toggleFavorite(String cca2) async {
    final currentFavorites = Set<String>.from(state.favoriteCca2Codes);
    
    if (currentFavorites.contains(cca2)) {
      currentFavorites.remove(cca2);
    } else {
      currentFavorites.add(cca2);
    }
    await _prefs.setStringList(_storageKey, currentFavorites.toList());
    
    emit(FavoritesState(favoriteCca2Codes: currentFavorites));
  }

  bool isFavorite(String cca2) => state.favoriteCca2Codes.contains(cca2);
}