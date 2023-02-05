// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stores_api/app/database/database_connection.dart' as _i4;
import 'package:stores_api/app/database/database_connection_configuration.dart'
    as _i5;
import 'package:stores_api/app/database/i_database_connection.dart' as _i3;
import 'package:stores_api/app/logger/i_logger.dart' as _i8;
import 'package:stores_api/app/modules/user/controller/auth_controller.dart'
    as _i11;
import 'package:stores_api/app/modules/user/repository/i_user_repository.dart'
    as _i6;
import 'package:stores_api/app/modules/user/repository/user_repository.dart'
    as _i7;
import 'package:stores_api/app/modules/user/service/i_service.dart' as _i9;
import 'package:stores_api/app/modules/user/service/user_service.dart' as _i10;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of main-scope dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.IDatabaseConnection>(
      () => _i4.DatabaseConnection(gh<_i5.DatabaseConnectionConfiguration>()));
  gh.lazySingleton<_i6.IUserRepository>(() => _i7.UserRepository(
        connection: gh<_i3.IDatabaseConnection>(),
        log: gh<_i8.ILogger>(),
      ));
  gh.lazySingleton<_i9.IUserService>(() => _i10.UserService(
        userRepository: gh<_i6.IUserRepository>(),
        log: gh<_i8.ILogger>(),
      ));
  gh.factory<_i11.AuthController>(() => _i11.AuthController(
        userService: gh<_i9.IUserService>(),
        log: gh<_i8.ILogger>(),
      ));
  return getIt;
}
