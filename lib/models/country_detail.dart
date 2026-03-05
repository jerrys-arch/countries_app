import 'package:equatable/equatable.dart';

class CountryDetail extends Equatable {
  final String commonName;
  final String flagPng;
  final String highResFlagUrl; 
  final String capital; 
  final int population;
  final String region;
  final String subregion;
  final double area;
  final List<String> timezones;

  const CountryDetail({
    required this.commonName,
    required this.flagPng,
    required this.highResFlagUrl,
    required this.capital,
    required this.population,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
  });

  factory CountryDetail.fromJson(Map<String, dynamic> json) {
    return CountryDetail(
      commonName: json['name']?['common'] ?? '',
      flagPng: json['flags']?['png'] ?? '',
      highResFlagUrl: json['flags']?['svg'] ?? json['flags']?['png'] ?? '',
      capital: (json['capital'] as List?)?.isNotEmpty == true 
          ? json['capital'][0] 
          : 'N/A',
      population: json['population'] ?? 0,
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      timezones: List<String>.from(json['timezones'] ?? []),
    );
  }

  @override
  List<Object?> get props => [commonName, population]; 
}