// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:template/src/network/api_provider.dart' as _i3;
import 'package:template/src/repositories/post_repository.dart' as _i5;
import 'package:template/src/screens/home/bloc/home_cubit.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initDependencies({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.ApiProvider>(_i3.ApiProvider());
    gh.factory<_i4.HomeState>(
        () => _i4.HomeState(status: gh<_i4.HomeStatus>()));
    gh.factory<_i5.PostRepository>(() => _i5.PostRepository());
    gh.factory<_i4.HomeCubit>(() => _i4.HomeCubit(gh<_i5.PostRepository>()));
    return this;
  }
}
