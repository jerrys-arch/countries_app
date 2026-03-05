import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final Set<String> favoriteCca2Codes;

  const FavoritesState({this.favoriteCca2Codes = const {}});

  @override
  List<Object?> get props => [favoriteCca2Codes];
}