import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/Updateprofile_Repository.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/Updateprofile_state.dart';

class UpdateprofileCubit extends Cubit<UpdateprofileState> {
  final UpdateprofileRepository profileupdateRepository;
  UpdateprofileCubit(this.profileupdateRepository) : super(UpdateProfileInitial());

  Future<void> Updateprofile(dynamic data) async {
    print('UpdateprofileCubit: Starting profile update');
    emit(UpdateProfileLoading());
    try {
      print('UpdateprofileCubit: Calling repository with data: $data');
      final response = await profileupdateRepository.Updateprofile(data);
      if (response != null) {
        print('UpdateprofileCubit: Response received: ${response.settings.toString()}');
        if (response.settings.success == 1) {
          print('UpdateprofileCubit: Success - ${response.settings?.message}');
          emit(UpdateProfileSuccessState(
            message: response.settings?.message ?? "Profile updated successfully",
            updateprofilemodel: response,
          ));
        } else {
          print('UpdateprofileCubit: Server error - ${response.settings?.message}');
          emit(UpdateProfileError(
            message: response.settings?.message ?? "Failed to update profile",
          ));
        }
      } else {
        print('UpdateprofileCubit: Null response from repository');
        emit(UpdateProfileError(message: "No response from server"));
      }
    } catch (e) {
      final errorMessage = e is DioException
          ? e.type == DioExceptionType.badResponse
          ? "Server error: ${e.response?.statusCode} - ${e.response?.data}"
          : "Network error: ${e.message ?? 'Unknown error'}"
          : "Unexpected error: $e";
      print('UpdateprofileCubit: Error - $errorMessage');
      emit(UpdateProfileError(message: errorMessage));
    }
  }
}