import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_cubit.dart';
import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_repository.dart';
import 'package:arkitek_app/bloc/login/login_cubit.dart';
import 'package:arkitek_app/bloc/login/login_repository.dart';
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
    ),
    RepositoryProvider<LoginRepository>(
      create: (context) => LoginRepositoryImpl(
          remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<AddEditPostRepository>(
      create: (context) => AddEditPostRepositoryImpl(
          remoteDataSource: context.read<RemoteDataSource>()),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<LoginRepository>()),
    ),
    BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<RegisterRepository>()),
    ),
    BlocProvider<ArcheticCubit>(
      create: (context) => ArcheticCubit(context.read<Archeticrepository>()),
    ),
    BlocProvider<AddEditPostCubit>(
      create: (context) =>
          AddEditPostCubit(context.read<AddEditPostRepository>()),
    ),
  ];
}
