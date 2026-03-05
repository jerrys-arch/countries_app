import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/country_repository.dart';
import 'detail_state.dart';
import '../../core/di/service_locator.dart'; 

class DetailCubit extends Cubit<DetailState> {
  final CountryRepository repository = getIt<CountryRepository>();

  DetailCubit() : super(DetailInitial());

  Future<void> getCountryDetails(String cca2) async {
    emit(DetailLoading());
    try {
      final country = await repository.fetchCountryDetails(cca2);
      emit(DetailLoaded(country));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}