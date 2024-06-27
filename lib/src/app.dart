import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/dependencies.dart';
import 'routes/app_routes.dart';
import 'routes/navigation_service.dart';
import 'routes/route_observer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/connectivity/connectivity_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<ConnectivityBloc>()),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
          ),
          locale: const Locale('vi', ''),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [MyRouteObserver()],
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          onGenerateInitialRoutes: (_) => AppRoutes.onGenerateInitialRoute(),
          navigatorKey: NavigationService.navigationKey,
        ),
      ),
    );
  }
}
