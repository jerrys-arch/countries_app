import 'package:equatable/equatable.dart';

class CountrySummary extends Equatable {
  final String commonName;
  final String flagPng;
  final int population;
  final String cca2;
  final String capital; 

  const CountrySummary({
    required this.commonName,
    required this.flagPng,
    required this.population,
    required this.cca2,
    required this.capital,
  });

  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? capitalList = json['capital'] as List?;

    return CountrySummary(
      commonName: json['name']['common'] ?? '',
      flagPng: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      cca2: json['cca2'] ?? '',
      capital: (capitalList != null && capitalList.isNotEmpty)
          ? capitalList.first.toString()
          : 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': commonName},
      'flags': {'png': flagPng},
      'population': population,
      'cca2': cca2,
      'capital': [capital], 
    };
  }
  @override
  List<Object?> get props => [cca2]; 
}