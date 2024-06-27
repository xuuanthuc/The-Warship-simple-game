import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: ScreenUtilInit(
          designSize: const Size(1024, 1366),
          minTextAdapt: true,
          splitScreenMode: true,
          enableScaleWH: () => kIsWeb ? false  : true,
          enableScaleText: () => kIsWeb ? false  : true,
          builder: (_, child){
           return MaterialApp(
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
            );
          },
        ),
      ),
    );
  }
}
