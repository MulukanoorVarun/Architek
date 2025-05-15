import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/UpdateProfileModel.dart';
import '../../../Model/RegisterModel.dart';

abstract class UpdateprofileState extends Equatable {
  const UpdateprofileState();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateprofileState {
  const UpdateProfileInitial();
}

class UpdateProfileLoading extends UpdateprofileState {
  const UpdateProfileLoading();
}

class UpdateProfileSuccessState extends UpdateprofileState {
  final Updateprofilemodel updateprofilemodel;
  final String message;

  const UpdateProfileSuccessState({
    required this.updateprofilemodel,
    required this.message,
  });

  @override
  List<Object?> get props => [updateprofilemodel, message];
}

class UpdateProfileError extends UpdateprofileState {
  final String message;

  const UpdateProfileError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}