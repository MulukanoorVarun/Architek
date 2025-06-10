import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;

  LoginCubit(this.loginRepository) : super(LoginIntially());

  Future<void> loginApi(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      final res = await loginRepository.loginApi(data);
      if (res != null) {
        emit(LoginLoaded(successModel: res));
      } else {
        emit(LoginError(message: "No data available"));
      }
    } catch (e) {
      emit(LoginError(message: "An error occurred: $e"));
    }
  }
}
