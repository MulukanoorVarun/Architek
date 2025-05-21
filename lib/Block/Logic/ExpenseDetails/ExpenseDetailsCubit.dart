import 'package:flutter_bloc/flutter_bloc.dart';
import 'ExpenseDetailsRepository.dart';
import 'ExpenseDetailsState.dart';

class GetExpenseDetailCubit extends Cubit<GetExpenseDetailsState> {
  final GetExpenseDetailRepo ExpenseDetailRepo;
  GetExpenseDetailCubit(this.ExpenseDetailRepo)
    : super(GetExpenseDetailIntailly());

  Future<void> GetExpenseDetails(String id) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.getExpensiveDetails(id);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(GetExpenseDetailLoaded(expenseDetailModel: res));
        }
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An Error Occured: $e"));
    }
  }

  Future<void> updateExpenseDetails(Map<String, dynamic> data) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.putExpensiveDetails(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(ExpenceDetailSuccess(successModel: res));
        }
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An Error Occured: $e"));
    }
  }
  Future<void> deleteExpenseDetails(String id) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.deleteExpensiveDetails(id);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(ExpenceDetailSuccess(successModel: res));
        }
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An Error Occured: $e"));
    }
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    emit(SaveExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.postExpenseUpdate(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(ExpenceDetailSuccess(successModel: res));
        } else {
          emit(GetExpenseDetailError(message: res.settings?.message ?? ''));
        }
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An Error Occured: $e"));
    }
  }
}
