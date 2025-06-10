import 'package:arkitek_app/routes/StateInjector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:arkitek_app/theme/app_theme.dart';
import 'package:arkitek_app/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ArkitekApp());
}

class ArkitekApp extends StatelessWidget {
  const ArkitekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiProvider(
        providers: StateInjector.blocProviders,
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
