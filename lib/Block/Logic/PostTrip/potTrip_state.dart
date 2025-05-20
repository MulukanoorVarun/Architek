import 'package:equatable/equatable.dart';
import '../../../Model/SuccessModel.dart';

abstract class postTripState extends Equatable {
  const postTripState();

  @override
  List<Object?> get props => [];
}

// Initial state when the registration process has not started
class PostTripInitial extends postTripState {
  const PostTripInitial();
}

// Loading state when the registration API call is in progress
class PostTripLoading extends postTripState {
  PostTripLoading();
}

// Success state when registration is successful
class PostTripSuccessState extends postTripState {
  final SuccessModel successModel;
  const PostTripSuccessState({required this.successModel});

  @override
  List<Object?> get props => [SuccessModel];
}

class PostTripError extends postTripState {
  final String message;

  const PostTripError({required this.message});

  @override
  List<Object?> get props => [message];
}
