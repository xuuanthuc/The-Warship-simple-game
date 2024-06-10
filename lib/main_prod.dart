import 'package:template/src/global/flavor/app_flavor.dart';

import './../../initial_app.dart';
import './../../src/app.dart';

void main() {
  AppFlavor.appFlavor = Flavor.release;
  initialApp(() => const MyApp());
}