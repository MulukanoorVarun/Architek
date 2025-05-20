import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/ExpenseDetailModel.dart';
import 'package:tripfin/Model/SuccessModel.dart';

import '../../../Model/GetTripModel.dart';

abstract class GetExpenseDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetExpenseDetailIntailly extends GetExpenseDetailsState {}

class GetExpenseDetailLoading extends GetExpenseDetailsState {}

class ExpenceDetailSuccess extends GetExpenseDetailsState {
  final SuccessModel successModel;
  ExpenceDetailSuccess({required this.successModel});
}

class GetExpenseDetailLoaded extends GetExpenseDetailsState {
  final ExpenseDetailModel expenseDetailModel;
  GetExpenseDetailLoaded({required this.expenseDetailModel});
}

class GetExpenseDetailError extends GetExpenseDetailsState {
  final String message;
  GetExpenseDetailError({required this.message});
}
