import 'package:flutter/material.dart';
import '../../routes/navigation_service.dart';
import '../../../l10n/l10n.dart';
import '../../routes/route_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  goToHome() async {
    await Future.delayed(const Duration(seconds: 1));
    navService.pushNamed(RouteKey.gameClient);
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
