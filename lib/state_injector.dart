import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Bloc/Logic/CategoryList/CategoryCubit.dart';
import 'package:tripfin/Bloc/Logic/CategoryList/CategoryRepository.dart';
import 'package:tripfin/Bloc/Logic/CombinedProfile/CombinedProfileCubit.dart';
import 'package:tripfin/Bloc/Logic/ForgotPassword/ForgotPassWordCubit.dart';
import 'package:tripfin/Bloc/Logic/ForgotPassword/ForgotPassWordRepository.dart';
import 'package:tripfin/Bloc/Logic/GetCurrency/GetCurrencyCubit.dart';
import 'package:tripfin/Bloc/Logic/GetCurrency/GetCurrencyRepository.dart';
import 'package:tripfin/Bloc/Logic/GetPreviousTripHistory/GetPreviousTripHistoryCubit.dart';
import 'package:tripfin/Bloc/Logic/GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import 'package:tripfin/Bloc/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Bloc/Logic/GetTrip/GetTripRepository.dart';
import 'package:tripfin/Bloc/Logic/LogInBloc/login_cubit.dart';
import 'package:tripfin/Bloc/Logic/LogInBloc/login_repository.dart';
import 'package:tripfin/Bloc/Logic/PiechartdataScreen/PiechartRepository.dart';
import 'package:tripfin/Bloc/Logic/PostTrip/postTrip_cubit.dart';
import 'package:tripfin/Bloc/Logic/Profiledetails/Profile_repository.dart';
import 'package:tripfin/Bloc/Logic/TripFinish/TripFinishCubit.dart';
import 'package:tripfin/Bloc/Logic/TripFinish/TripFinishRepository.dart';
import 'package:tripfin/Bloc/Logic/UpdateProfile/UpdateProfileCubit.dart';
import 'package:tripfin/Bloc/Logic/UpdateProfile/UpdateProfileRepository.dart';
import 'package:tripfin/Bloc/Logic/delete_account/DeleteAccountRepository.dart';
import 'package:tripfin/Services/remote_data_source.dart';
import 'Bloc/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import 'Bloc/Logic/ExpenseDetails/ExpenseDetailsRepository.dart';
import 'Bloc/Logic/Home/HomeCubit.dart';
import 'Bloc/Logic/Internet/internet_status_bloc.dart';
import 'Bloc/Logic/PiechartdataScreen/PiechartCubit.dart';
import 'Bloc/Logic/PostTrip/postTrip_repository.dart';
import 'Bloc/Logic/Profiledetails/Profile_cubit.dart';
import 'Bloc/Logic/RegisterBloc/Register_cubit.dart';
import 'Bloc/Logic/RegisterBloc/Register_repository.dart';
import 'Bloc/Logic/TripCount/TripcountCubit.dart';
import 'Bloc/Logic/TripCount/TripcountRepository.dart';
import 'Bloc/Logic/delete_account/DeleteAccountCubit.dart';

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
    RepositoryProvider<Piechartrepository>(
      create:
          (context) =>
              PiedataImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetTripRep>(
      create:
          (context) =>
              GetTripImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CurrencyRepo>(
      create: (context) => CurrencyImpl(context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<GetProfileRepo>(
      create:
          (context) => GetProfileImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<PostTripRepository>(
      create:
          (context) =>
              PostTripImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<Tripcountrepository>(
      create:
          (context) => GetTripcountImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<GetPreviousTripRepo>(
      create:
          (context) => GetPreviousTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<GetPreviousTripRepo>(
      create:
          (context) => GetPreviousTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<Categoryrepository>(
      create:
          (context) => GetcategoryImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<GetExpenseDetailRepo>(
      create:
          (context) => GetExpenseDetailImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<UpdateProfileRepository>(
      create:
          (context) => UpdateProfileImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),

    RepositoryProvider<TripFinishRepository>(
      create:
          (context) => FinishTripImpl(
            remoteDataSource: context.read<RemoteDataSource>(),
          ),
    ),
    RepositoryProvider<ForgotPasswordRepository>(
      create:
          (context) => ForgotPasswordImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<Deleteaccountrepository>(
      create:
          (context) => DeleteaccountrepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
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
      create:
          (context) =>
              GetPreviousTripHistoryCubit(context.read<GetPreviousTripRepo>()),
    ),
    BlocProvider<GetCurrencyCubit>(
      create: (context) => GetCurrencyCubit(context.read<CurrencyRepo>()),
    ),
    BlocProvider<HomeCubit>(
      create:
          (context) => HomeCubit(
            context.read<GetTripRep>(),
            context.read<GetPreviousTripRepo>(),
            context.read<GetProfileRepo>(),
          ),
    ),
    BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(context.read<GetProfileRepo>()),
    ),
    BlocProvider<Tripcountcubit>(
      create: (context) => Tripcountcubit(context.read<Tripcountrepository>()),
    ),

    BlocProvider<Categorycubit>(
      create: (context) => Categorycubit(context.read<Categoryrepository>()),
    ),
    BlocProvider<Tripcountcubit>(
      create: (context) => Tripcountcubit(context.read<Tripcountrepository>()),
    ),
    BlocProvider<CombinedProfileCubit>(
      create:
          (context) => CombinedProfileCubit(
            getProfileRepo: context.read<GetProfileRepo>(),
            tripcountrepository: context.read<Tripcountrepository>(),
          ),
    ),

    BlocProvider<PiechartCubit>(
      create: (context) => PiechartCubit(context.read<Piechartrepository>()),
    ),
    BlocProvider<GetExpenseDetailCubit>(
      create:
          (context) =>
              GetExpenseDetailCubit(context.read<GetExpenseDetailRepo>()),
    ),
    BlocProvider<postTripCubit>(
      create: (context) => postTripCubit(context.read<PostTripRepository>()),
    ),
    BlocProvider<UpdateProfileCubit>(
      create:
          (context) =>
              UpdateProfileCubit(context.read<UpdateProfileRepository>()),
    ),
    BlocProvider<TripFinishCubit>(
      create:
          (context) => TripFinishCubit(context.read<TripFinishRepository>()),
    ),
    BlocProvider<ForgotPasswordCubit>(
      create:
          (context) => ForgotPasswordCubit(context.read<ForgotPasswordRepository>()),
    ),
    BlocProvider<DeleteAccountCubit>(
      create:
          (context) => DeleteAccountCubit(context.read<Deleteaccountrepository>()),
    ),
  ];
}
