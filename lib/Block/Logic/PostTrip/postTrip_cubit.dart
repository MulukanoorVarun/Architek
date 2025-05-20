import 'package:flutter_bloc/flutter_bloc.dart';

import 'postTrip_repository.dart';
import 'potTrip_state.dart';

class postTripCubit extends Cubit<postTripState> {
  final PostTripRepository postTripRepository;

  postTripCubit(this.postTripRepository) : super(PostTripInitial());

  Future<void> postTrip(Map<String, dynamic> data) async {
    emit(PostTripLoading());
    try {
      final response = await postTripRepository.postTrip(data);
      if (response != null) {
        if (response.settings?.success == 1) {
          emit(PostTripSuccessState(successModel: response));
        } else {
          emit(PostTripError(message: response.settings?.message ?? ""));
        }
      } else {
        emit(PostTripError(message: "No response received."));
      }
    } catch (e) {
      emit(PostTripError(message: e.toString()));
    }
  }
}
