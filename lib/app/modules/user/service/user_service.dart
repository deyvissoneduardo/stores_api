import 'package:injectable/injectable.dart';
import 'package:stores_api/app/entities/user.dart';
import 'package:stores_api/app/helpers/jwt_helpers.dart';
import 'package:stores_api/app/logger/i_logger.dart';
import 'package:stores_api/app/modules/user/repository/i_user_repository.dart';
import 'package:stores_api/app/modules/user/service/i_service.dart';
import 'package:stores_api/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:stores_api/app/modules/user/view_models/user_save_input_model.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;
  UserService({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) async {
    final userEntity = User(
      name: user.name,
      email: user.email,
      password: user.password,
    );

    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) =>
      userRepository.loginWithEmailAndPassword(email, password);

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelpers.refreshToken(inputModel.accessToken);
    final user = User(
      id: inputModel.userId,
      refreshToken: refreshToken,
    );
    await userRepository.updateRefreshToken(user);
    return refreshToken;
  }
}
