import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/models/project.dart';
import 'package:arkitek_app/repositories/project_repository.dart';

// Events
abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProjects extends ProjectEvent {
  const LoadUserProjects();
}

class LoadProjectDetails extends ProjectEvent {
  final String id;

  const LoadProjectDetails(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProject extends ProjectEvent {
  final Project project;

  const CreateProject(this.project);

  @override
  List<Object?> get props => [project];
}

class UpdateProject extends ProjectEvent {
  final Project project;

  const UpdateProject(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProject extends ProjectEvent {
  final String id;

  const DeleteProject(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterProjects extends ProjectEvent {
  final String status;

  const FilterProjects({required this.status});

  @override
  List<Object?> get props => [status];
}

// States
abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;

  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectDetailsLoaded extends ProjectState {
  final Project project;

  const ProjectDetailsLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectCreated extends ProjectState {
  final Project project;

  const ProjectCreated(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectUpdated extends ProjectState {
  final Project project;

  const ProjectUpdated(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectDeleted extends ProjectState {
  const ProjectDeleted();
}

class ProjectsError extends ProjectState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;

  ProjectBloc({required this.repository}) : super(const ProjectsInitial()) {
    on<LoadUserProjects>(_onLoadUserProjects);
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<CreateProject>(_onCreateProject);
    on<UpdateProject>(_onUpdateProject);
    on<DeleteProject>(_onDeleteProject);
    on<FilterProjects>(_onFilterProjects);
  }

  Future<void> _onLoadUserProjects(LoadUserProjects event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      final projects = await repository.getUserProjects();
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onLoadProjectDetails(LoadProjectDetails event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      final project = await repository.getProjectById(event.id);
      emit(ProjectDetailsLoaded(project));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onCreateProject(CreateProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      final project = await repository.createProject(event.project);
      emit(ProjectCreated(project));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(UpdateProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      final project = await repository.updateProject(event.project);
      emit(ProjectUpdated(project));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(DeleteProject event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      await repository.deleteProject(event.id);
      emit(const ProjectDeleted());
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onFilterProjects(FilterProjects event, Emitter<ProjectState> emit) async {
    emit(const ProjectsLoading());
    try {
      final projects = await repository.filterProjects(status: event.status);
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }
}