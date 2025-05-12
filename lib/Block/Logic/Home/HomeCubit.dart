import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/GetTripModel.dart';

import '../../../Model/GetPrevousTripModel.dart';
import '../GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import '../GetTrip/GetTripRepository.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTripRep getTripRep;
  final GetPreviousTripRepo getPreviousTripRepo;

  HomeCubit(this.getTripRep, this.getPreviousTripRepo) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final futures = <Future<dynamic>>[];

      final results = await Future.wait(futures);

      final getTripData = results[0] as GetTripModel;
      final getpreiousTripHistoryData = results[1] as GetPrevousTripModel;

      emit(
        HomeLoaded(
          getTripModel: getTripData,
          getPrevousTripModel: getpreiousTripHistoryData,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("HomeCubit Error: $e\n$stackTrace");
      emit(HomeError("Failed to fetch home data. Please try again later."));
    }
  }
}
