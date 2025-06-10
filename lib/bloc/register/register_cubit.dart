import 'package:arkitek_app/bloc/register/register_repository.dart';
import 'package:arkitek_app/bloc/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository registerRepository;

  RegisterCubit(this.registerRepository) : super(RegisterIntially());

  Future<void> registerAPi(Map<String, dynamic> data) async {
    emit(RegisterLoading());
    try {
      final res = await registerRepository.registerApi(data);
      if (res != null) {
        emit(RegisterLoaded(successModel: res));
      } else {
        emit(RegisterError(message: "No data available"));
      }
    } catch (e) {
      emit(RegisterError(message: "An error occurred: $e"));
    }
  }
}
