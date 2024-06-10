import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/global_bloc/connectivity/connectivity_bloc.dart';
import 'package:template/src/global_bloc/settings/app_settings_bloc.dart';
import '../../global/routes/navigation_service.dart';
import '../../../l10n/l10n.dart';
import '../../global/routes/route_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  goToHome() async {
    await Future.delayed(const Duration(seconds: 1));
    navService.pushNamed(RouteKey.root);
  }

  @override
  void didChangeDependencies() {
    goToHome();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(AppLocalizations.of(context)!.hello('thuc')),
      ),
    );
  }
}
