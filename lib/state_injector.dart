import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryCubit.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripRepository.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_cubit.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Services/remote_data_source.dart';
import 'Block/Logic/RegisterBloc/Register_cubit.dart';
import 'Block/Logic/RegisterBloc/Register_repository.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<RegisterRepository>(
      create:
          (context) =>
              RegisterImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<LoginRepository>(
      create:
          (context) =>
              LoginImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetTripRep>(
      create:
          (context) =>
              GetTripImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetPreviousTripRepo>(
      create:
          (context) => GetPreviousTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<RegisterRepository>()),
    ),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(context.read<LoginRepository>()),
    ),
    BlocProvider<GetTripCubit>(
      create: (context) => GetTripCubit(context.read<GetTripRep>()),
    ),
    BlocProvider<GetPreviousTripHistoryCubit>(
      create: (context) => GetPreviousTripHistoryCubit(context.read<GetPreviousTripRepo>()),
    ),
  ];
}
