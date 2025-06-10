import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:arkitek_app/services/authentication_service.dart';
import 'package:arkitek_app/theme/app_theme.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:arkitek_app/blocs/auth/auth_bloc.dart';
import 'package:arkitek_app/blocs/architect/architect_bloc.dart';
import 'package:arkitek_app/blocs/project/project_bloc.dart';
import 'package:arkitek_app/repositories/architect_repository.dart';
import 'package:arkitek_app/repositories/project_repository.dart';
import 'package:arkitek_app/repositories/user_repository.dart';
import 'package:arkitek_app/services/remote_data_source.dart';
import 'blocs/archeticlist/ArcheticCubit.dart';
import 'blocs/archeticlist/ArcheticRepository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArkitekApp());
}

class ArkitekApp extends StatelessWidget {
  const ArkitekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RemoteDataSource>(
          create: (context) => RemoteDataSourceImpl(),
        ),
        RepositoryProvider(
          create: (context) => ArchitectRepository(),
        ),
        RepositoryProvider<Archeticrepository>(
          create: (context) => GetcategoryImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
        ),
        RepositoryProvider<ProjectRepository>(
          create: (context) => ProjectRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      child: MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authService: context.read<AuthenticationService>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ArchitectBloc(
              repository: context.read<ArchitectRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProjectBloc(
              repository: context.read<ProjectRepository>(),
            ),
          ),
          BlocProvider<ArcheticCubit>(
            create:
                (context) => ArcheticCubit(context.read<Archeticrepository>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Arkitek',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
