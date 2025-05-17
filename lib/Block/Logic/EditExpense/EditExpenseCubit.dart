import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/EditExpense/EditExpenseRepository.dart';

import 'EditExpenseState.dart';

class Editexpensecubit extends Cubit<Editexpensestate> {
  final Editexpenserepository editexpenserepository;
  Editexpensecubit(this.editexpenserepository) : super(EditExpenseInitial());

  Future<void> EditExpense(Map<String, dynamic> data) async {
    emit(EditExpenseLoading());
    try {
      final res = await editexpenserepository.Editexpense(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(EditExpenseSuccessState(editexpencemodel: res, message: res.settings?.message ?? ''));
        } else {
          emit(EditExpenseError(message: res.settings?.message ?? ''));
        }
      }
    } catch (e) {
      emit(EditExpenseError(message: e.toString()));
    }
  }
}