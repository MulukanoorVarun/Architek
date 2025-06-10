import 'package:equatable/equatable.dart';

import '../../models/ArchitectModel.dart';

abstract class Archeticstate extends Equatable {
  @override
  List<Object?> get props => [];
}

class archeticIntailly extends Archeticstate {}

class archeticLoading extends Archeticstate {}

class archeticLoaded extends Archeticstate {
  final ArchitectModel architectModel;
  archeticLoaded({required this.architectModel});
}

class archeticError extends Archeticstate {
  final String message;
  archeticError({required this.message});
}
