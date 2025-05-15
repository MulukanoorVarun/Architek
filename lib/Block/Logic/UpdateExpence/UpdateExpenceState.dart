import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/UpdateExpenceModel.dart';
import '../../../Model/RegisterModel.dart';
import '../../../Model/SuccessModel.dart';

// Abstract base state for registration, using Equatable for state comparison
abstract class UpdateExpenseState extends Equatable {
  const UpdateExpenseState();

  @override
  List<Object?> get props => [];
}

class UpdateExpenseInitial extends UpdateExpenseState {}

class UpdateExpenseLoading extends UpdateExpenseState {}

class UpdateExpenseSuccessState extends UpdateExpenseState {
  final SuccessModel successModel;
  final String message;

  const UpdateExpenseSuccessState({
    required this.successModel,
    required this.message,
  });

  @override
  List<Object?> get props => [successModel, message];
}

class UpdateExpenseError extends UpdateExpenseState {
  final String message;

  const UpdateExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}