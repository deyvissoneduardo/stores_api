import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:stores_api/app/database/database_connection_configuration.dart';

import './i_database_connection.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection implements IDatabaseConnection {
  final DatabaseConnectionConfiguration _configuration;

  DatabaseConnection(this._configuration);
  @override
  Future<MySqlConnection> openConnection() async {
    return MySqlConnection.connect(ConnectionSettings(
      host: _configuration.host,
      user: _configuration.user,
      password: _configuration.password,
      db: _configuration.databaseName,
      port: _configuration.port,
    ));
  }
}
