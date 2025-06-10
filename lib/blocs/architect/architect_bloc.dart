import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/models/architect.dart';
import 'package:arkitek_app/repositories/architect_repository.dart';

// Events
abstract class ArchitectEvent extends Equatable {
  const ArchitectEvent();

  @override
  List<Object?> get props => [];
}

class LoadArchitects extends ArchitectEvent {
  const LoadArchitects();
}

class LoadFeaturedArchitects extends ArchitectEvent {
  const LoadFeaturedArchitects();
}

class LoadArchitectDetails extends ArchitectEvent {
  final String id;

  const LoadArchitectDetails(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchArchitects extends ArchitectEvent {
  final String query;

  const SearchArchitects(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterArchitects extends ArchitectEvent {
  final List<String> specializations;
  final double minBudget;
  final double maxBudget;
  final int minExperience;

  const FilterArchitects({
    required this.specializations,
    required this.minBudget,
    required this.maxBudget,
    required this.minExperience,
  });

  @override
  List<Object?> get props => [
    specializations,
    minBudget,
    maxBudget,
    minExperience,
  ];
}

// States
abstract class ArchitectState extends Equatable {
  const ArchitectState();

  @override
  List<Object?> get props => [];
}

class ArchitectsInitial extends ArchitectState {
  const ArchitectsInitial();
}

class ArchitectsLoading extends ArchitectState {
  const ArchitectsLoading();
}

class ArchitectsLoaded extends ArchitectState {
  final List<Architect> architects;

  const ArchitectsLoaded(this.architects);

  @override
  List<Object?> get props => [architects];
}

class FeaturedArchitectsLoaded extends ArchitectState {
  final List<Architect> architects;

  const FeaturedArchitectsLoaded(this.architects);

  @override
  List<Object?> get props => [architects];
}

class ArchitectDetailsLoaded extends ArchitectState {
  final Architect architect;

  const ArchitectDetailsLoaded(this.architect);

  @override
  List<Object?> get props => [architect];
}

class ArchitectsError extends ArchitectState {
  final String message;

  const ArchitectsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ArchitectBloc extends Bloc<ArchitectEvent, ArchitectState> {
  final ArchitectRepository repository;

  ArchitectBloc({required this.repository}) : super(const ArchitectsInitial()) {
    on<LoadArchitects>(_onLoadArchitects);
    on<LoadFeaturedArchitects>(_onLoadFeaturedArchitects);
    on<LoadArchitectDetails>(_onLoadArchitectDetails);
    on<SearchArchitects>(_onSearchArchitects);
    on<FilterArchitects>(_onFilterArchitects);
  }

  Future<void> _onLoadArchitects(LoadArchitects event, Emitter<ArchitectState> emit) async {
    emit(const ArchitectsLoading());
    try {
      final architects = await repository.getArchitects();
      emit(ArchitectsLoaded(architects));
    } catch (e) {
      emit(ArchitectsError(e.toString()));
    }
  }

  Future<void> _onLoadFeaturedArchitects(LoadFeaturedArchitects event, Emitter<ArchitectState> emit) async {
    emit(const ArchitectsLoading());
    try {
      final architects = await repository.getFeaturedArchitects();
      emit(FeaturedArchitectsLoaded(architects));
    } catch (e) {
      emit(ArchitectsError(e.toString()));
    }
  }

  Future<void> _onLoadArchitectDetails(LoadArchitectDetails event, Emitter<ArchitectState> emit) async {
    emit(const ArchitectsLoading());
    try {
      final architect = await repository.getArchitectById(event.id);
      emit(ArchitectDetailsLoaded(architect));
    } catch (e) {
      emit(ArchitectsError(e.toString()));
    }
  }

  Future<void> _onSearchArchitects(SearchArchitects event, Emitter<ArchitectState> emit) async {
    emit(const ArchitectsLoading());
    try {
      final architects = await repository.searchArchitects(event.query);
      emit(ArchitectsLoaded(architects));
    } catch (e) {
      emit(ArchitectsError(e.toString()));
    }
  }

  Future<void> _onFilterArchitects(FilterArchitects event, Emitter<ArchitectState> emit) async {
    emit(const ArchitectsLoading());
    try {
      final architects = await repository.filterArchitects(
        specializations: event.specializations,
        minBudget: event.minBudget,
        maxBudget: event.maxBudget,
        minExperience: event.minExperience,
      );
      emit(ArchitectsLoaded(architects));
    } catch (e) {
      emit(ArchitectsError(e.toString()));
    }
  }
}