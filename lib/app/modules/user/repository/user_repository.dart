// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:stores_api/app/database/i_database_connection.dart';
import 'package:stores_api/app/entities/user.dart';
import 'package:stores_api/app/exception/database_exception.dart';
import 'package:stores_api/app/exception/user_exists_exception.dart';
import 'package:stores_api/app/exception/user_not_found_exception.dart';
import 'package:stores_api/app/helpers/crypt_helper.dart';
import 'package:stores_api/app/logger/i_logger.dart';
import 'package:stores_api/app/modules/user/repository/i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
   MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = ''' 
        INSERT users(name, email, password)
        VALUES(?,?,?)
      ''';
      final result = await conn.query(query, [
        user.name,
        user.email,
        CryptHelper.generateSha256Hash(user.password ?? ''),
      ]);

      final userId = result.insertId;

      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('users.email_UNIQUE')) {
        log.error('Usuario ja cadastrado no banco', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException(
        message: 'Erro ao criar usuario no banco $e',
        exception: e,
      );
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var query = ''' 
        SELECT * FROM users 
        WHERE email = ?
        AND password = ?
      ''';
      final result = await conn.query(query, [
        email,
        CryptHelper.generateSha256Hash(password),
      ]);

      if (result.isEmpty) {
        log.error('Usuario ou senha invaldo');
        throw UserNotfoundException(message: 'Usuario ou senha invaldo');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          password: (userSqlData['senha'] as Blob?).toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?).toString(),
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao logar usuario', e, s);
      throw DatabaseException(
        message: e.message,
        exception: e,
      );
    } finally {
      await conn?.close();
    }
  }
}
