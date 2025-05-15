import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/UpdateExpence/UpdateExpenceRepository.dart';
import 'package:tripfin/Block/Logic/UpdateExpence/UpdateExpenceState.dart';
import 'package:tripfin/Screens/Views/UpdateExpenceScreen.dart';

class UpdateExpenseCubit extends Cubit<UpdateExpenseState> {
  final UpdateExpenseRepository updateExpenseRepository;
  UpdateExpenseCubit(this.updateExpenseRepository) : super(UpdateExpenseInitial());

  Future<void> addExpense(Map<String, dynamic> data) async {
    emit(UpdateExpenseLoading());
    try {
      final res = await updateExpenseRepository.postExpenseUpdate(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(UpdateExpenseSuccessState(successModel: res, message: res.settings?.message ?? ''));
        } else {
          emit(UpdateExpenseError(message: res.settings?.message ?? ''));
        }
      }
    } catch (e) {
      emit(UpdateExpenseError(message: e.toString()));
    }
  }
}