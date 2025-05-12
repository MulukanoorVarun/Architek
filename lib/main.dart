import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Screens/Authentication/Login_Screen.dart';
import 'package:tripfin/Screens/Authentication/RegisterScreen.dart';
import 'package:tripfin/Screens/Home/DashboardScreen.dart';
import 'package:tripfin/Screens/Home/FinishTripScreen.dart';
import 'package:tripfin/Screens/Home/Onboardscreen.dart';
import 'package:tripfin/Screens/Home/OutOfBudgetScreen.dart';
import 'package:tripfin/Screens/Home/PerfectScreen.dart';
import 'package:tripfin/state_injector.dart';

import 'Screens/Home/ChartScreen.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home:  FinishTripScreen(amountSaved: 48200),
        ),
      ),
    );
  }
}
