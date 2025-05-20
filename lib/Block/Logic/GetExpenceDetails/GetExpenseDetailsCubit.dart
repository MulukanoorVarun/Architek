import 'package:flutter_bloc/flutter_bloc.dart';
import 'GetExpenseDetailsRepository.dart';
import 'GetExpenseDetailsState.dart';

class GetExpenseDetailCubit extends Cubit<GetExpenseDetailsState> {
  final GetExpenseDetailRepo getExpenseDetailRepo;

  GetExpenseDetailCubit(this.getExpenseDetailRepo) : super(GetExpenseDetailIntailly());
  Future<void> GetExpenseDetails(String id) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await getExpenseDetailRepo.getExpensiveDetails(id);
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
}
