import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/models/user.dart';
import 'package:arkitek_app/services/authentication_service.dart';
import 'package:arkitek_app/repositories/user_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LogIn extends AuthEvent {
  final String email;
  final String password;

  const LogIn({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String userType;

  const SignUp({
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [name, email, password, userType];
}

class LogOut extends AuthEvent {
  const LogOut();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationService authService;
  final UserRepository userRepository;

  AuthBloc({
    required this.authService,
    required this.userRepository,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogIn>(_onLogIn);
    on<SignUp>(_onSignUp);
    on<LogOut>(_onLogOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final isAuthenticated = await authService.isAuthenticated();
      if (isAuthenticated) {
        final userId = await authService.getUserId();
        if (userId != null) {
          final user = await userRepository.getUserById(userId);
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogIn(LogIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final userId = await authService.login(
        email: event.email,
        password: event.password,
      );
      if (userId != null) {
        final user = await userRepository.getUserById(userId);
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final userId = await authService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        userType: event.userType,
      );
      if (userId != null) {
        final user = await userRepository.getUserById(userId);
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to create account'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOut event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authService.logout();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}