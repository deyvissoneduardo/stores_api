import 'package:stores_api/app/entities/user.dart';
import 'package:stores_api/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:stores_api/app/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> loginWithEmailAndPassword(String email, String password);
  Future<String> confirmLogin(UserConfirmInputModel userConfirmLoginInput);
}
