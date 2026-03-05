import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/country_repository.dart';
import '../../models/country_summary.dart';
import 'country_state.dart';
import '../../core/di/service_locator.dart'; 

class CountryCubit extends Cubit<CountryState> {
  final CountryRepository repository = getIt<CountryRepository>();
  List<CountrySummary> _allCountries = [];
  String _currentSearchQuery = "";
  CountryCubit() : super(CountryInitial());

  Future<void> getAllCountries() async {
    emit(CountryLoading());
    try {
      _allCountries = await repository.fetchAllCountries();
      _allCountries.sort((a, b) => a.commonName.toLowerCase().compareTo(b.commonName.toLowerCase()));
      emit(CountryLoaded(List.from(_allCountries)));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }

  void searchCountries(String query) {
    _currentSearchQuery = query;
    if (query.isEmpty) {
      emit(CountryLoaded(List.from(_allCountries)));
      return;
    }

    final filtered = _allCountries.where((country) {
      return country.commonName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(CountryLoaded(List.from(filtered)));
  }

  void sortCountries({required bool byName}) {
    if (byName) {
      _allCountries.sort((a, b) => 
        a.commonName.toLowerCase().compareTo(b.commonName.toLowerCase()));
    } else {
      _allCountries.sort((a, b) => b.population.compareTo(a.population));
    }
    searchCountries(_currentSearchQuery);
  }
}