import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'dependencies.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initDependencies')

void configureDependencies() => getIt.$initDependencies();
