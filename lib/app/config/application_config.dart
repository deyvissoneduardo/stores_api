import 'package:dotenv/dotenv.dart' show env, load;
import 'package:shelf_router/shelf_router.dart';
import 'package:stores_api/app/config/service_locator_config.dart';
import 'package:stores_api/app/database/database_connection_configuration.dart';
import 'package:get_it/get_it.dart';
import 'package:stores_api/app/logger/i_logger.dart';
import 'package:stores_api/app/logger/logger.dart';
import 'package:stores_api/app/routers/router_configure.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependecies();
    _loadRoutersConfigure(router);
  }

  Future<void> _loadEnv() async => load();

  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfiguration(
      host: env['DATABASE_HOST'] ?? env['databaseHost']!,
      user: env['DATABASE_USER'] ?? env['databaseUser']!,
      port: int.tryParse(env['  '] ?? env['databasePort']!) ?? 0,
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
      databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
    );
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() =>
      GetIt.instance.registerLazySingleton<ILogger>(() => Logger());

  void _loadDependecies() => configureDependencies();

  void _loadRoutersConfigure(Router router) =>
      RouterConfigure(router).configure(router);
}
