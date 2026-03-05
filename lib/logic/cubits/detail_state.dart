import 'package:equatable/equatable.dart';
import '../../models/country_detail.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final CountryDetail country;

  const DetailLoaded(this.country);

  @override
  List<Object?> get props => [country];
}

class DetailError extends DetailState {
  final String message;

  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}