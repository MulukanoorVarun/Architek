import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/EditExpenceModel.dart';

abstract class Editexpensestate extends Equatable {
  const Editexpensestate();

  @override
  List<Object?> get props => [];
}

class EditExpenseInitial extends Editexpensestate {}

class EditExpenseLoading extends Editexpensestate {}

class EditExpenseSuccessState extends Editexpensestate {
  final Editexpencemodel editexpencemodel;
  final String message;

  const EditExpenseSuccessState({
    required this.editexpencemodel,
    required this.message,
  });

  @override
  List<Object?> get props => [editexpencemodel, message];
}

class EditExpenseError extends Editexpensestate {
  final String message;

  const EditExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}