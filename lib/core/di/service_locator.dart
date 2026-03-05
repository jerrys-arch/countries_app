import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/country_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<Dio>(() => Dio(
    BaseOptions(baseUrl: 'https://restcountries.com/v3.1/'),
  ));
  getIt.registerLazySingleton<CountryRepository>(
    () => CountryRepository(getIt<Dio>()),
  );
}