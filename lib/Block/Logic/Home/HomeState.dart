import 'package:equatable/equatable.dart';

import '../../../Model/GetPrevousTripModel.dart';
import '../../../Model/GetTripModel.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final GetPrevousTripModel getPrevousTripModel;
  final GetTripModel getTripModel;

  HomeLoaded({required this.getPrevousTripModel, required this.getTripModel});
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
