import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/country_summary.dart';
import '../../models/country_detail.dart';

class CountryRepository {
  final Dio _dio;
  static const String _allCountriesKey = 'cached_all_countries';
  static const String _detailPrefix = 'cached_detail_';

  CountryRepository(this._dio);
  Future<List<CountrySummary>> fetchAllCountries() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _dio.get(
        'all',
        queryParameters: {
          'fields': 'name,flags,population,cca2,capital',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        await prefs.setString(_allCountriesKey, jsonEncode(data));
        
        return data.map((json) => CountrySummary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries');
      }
    } on DioException catch (_) {
      final String? cachedData = prefs.getString(_allCountriesKey);
      
      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        return decodedData.map((json) => CountrySummary.fromJson(json)).toList();
      }
      throw Exception('No internet connection and no cached data found.');
    }
  }
  Future<CountryDetail> fetchCountryDetails(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final String cacheKey = '$_detailPrefix$cca2';

    try {
      final response = await _dio.get(
        'alpha/$cca2',
        queryParameters: {
          'fields': 'name,flags,population,capital,region,subregion,area,timezones',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data is List ? response.data[0] : response.data;
        await prefs.setString(cacheKey, jsonEncode(data));
        
        return CountryDetail.fromJson(data);
      } else {
        throw Exception('Failed to load country details');
      }
    } on DioException catch (_) {
      final String? cachedDetail = prefs.getString(cacheKey);
      
      if (cachedDetail != null) {
        return CountryDetail.fromJson(jsonDecode(cachedDetail));
      }
      
      throw Exception('Detail not available offline. Please connect to the internet.');
    }
  }
}