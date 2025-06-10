import 'package:equatable/equatable.dart';

import '../../models/SuccessModel.dart';

abstract class AddEditPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddEditPostIntially extends AddEditPostState {}

class AddEditPostLoading extends AddEditPostState {}

class AddEditPostLoaded extends AddEditPostState {
  final SuccessModel successModel;
  AddEditPostLoaded({required this.successModel});
}

class AddEditPostError extends AddEditPostState {
  final String message;
  AddEditPostError({required this.message});
}
