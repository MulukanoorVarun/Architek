import 'package:arkitek_app/services/remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    // BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
  ];
}
