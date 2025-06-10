import 'package:arkitek_app/blocs/archeticlist/ArcheticRepository.dart';
import 'package:arkitek_app/blocs/archeticlist/ArcheticState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArcheticCubit extends Cubit<Archeticstate> {
  final Archeticrepository archeticrepository;

  ArcheticCubit(this.archeticrepository) : super(archeticIntailly());

  Future<void> getarchitecture() async {
    emit(archeticLoading());
    try {
      final res = await archeticrepository.getArchetic();
      if (res != null) {
        emit(archeticLoaded(architectModel: res));
      } else {
        emit(archeticError(message: "No data available"));
      }
    } catch (e) {
      emit(archeticError(message: "An error occurred: $e"));
    }
  }
}
