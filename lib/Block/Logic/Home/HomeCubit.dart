import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/GetTripModel.dart';

import '../../../Model/GetPrevousTripModel.dart';
import '../../../Model/GetProfileModel.dart';
import '../GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import '../GetTrip/GetTripRepository.dart';
import '../Profiledetails/Profile_repository.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTripRep getTripRep;
  final GetPreviousTripRepo getPreviousTripRepo;
  final GetProfileRepo getProfileRepo;

  HomeCubit(this.getTripRep, this.getPreviousTripRepo, this.getProfileRepo)
    : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final futures = [
        getTripRep.getTrip(),
        getPreviousTripRepo.getPreviousTripHistory(),
        getProfileRepo.getProfile(),
      ];

      final results = await Future.wait(futures);

      final getTripData = results[0] as GetTripModel;
      final getpreiousTripHistoryData = results[1] as GetPrevousTripModel;
      final profileData = results[2] as GetprofileModel;

      emit(
        HomeLoaded(
          getTripModel: getTripData,
          getPrevousTripModel: getpreiousTripHistoryData,
          profileModel: profileData,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("HomeCubit Error: $e\n$stackTrace");
      emit(HomeError("Failed to fetch home data. Please try again later."));
    }
  }
}
