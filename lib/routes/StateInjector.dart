import 'package:arkitek_app/bloc/register/register_repository.dart';
import 'package:arkitek_app/services/remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/archeticlist/ArcheticCubit.dart';
import '../bloc/archeticlist/ArcheticRepository.dart';
import '../bloc/register/register_cubit.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<Archeticrepository>(
      create: (context) =>
          GetcategoryImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<RegisterRepository>(
      create: (context) => RegisterRepositoryImpl(
          remoteDataSource: context.read<RemoteDataSource>()),
    )
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<RegisterRepository>()),
    ),
    BlocProvider<ArcheticCubit>(
      create: (context) => ArcheticCubit(context.read<Archeticrepository>()),
    ),
  ];
}
