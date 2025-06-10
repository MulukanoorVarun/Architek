
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ArcheticRepository.dart';
import 'ArcheticState.dart';

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
