import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:stores_api/app/entities/user.dart';
import 'package:stores_api/app/exception/user_exists_exception.dart';
import 'package:stores_api/app/exception/user_not_found_exception.dart';
import 'package:stores_api/app/helpers/jwt_helpers.dart';
import 'package:stores_api/app/logger/i_logger.dart';
import 'package:stores_api/app/modules/user/service/i_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:stores_api/app/modules/user/view_models/login_view_model.dart';
import 'package:stores_api/app/modules/user/view_models/user_confirm_input_model.dart';
import 'package:stores_api/app/modules/user/view_models/user_save_input_model.dart';
part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  Router get router => _$AuthControllerRouter(this);

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;
      user = await userService.loginWithEmailAndPassword(
          loginViewModel.email, loginViewModel.password);
      return Response.ok(jsonEncode(
        {'access_token': JwtHelpers.generateJWT(user.id!)},
      ));
    } on UserNotfoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuario ou senha invalido'}));
    } catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao realizar login'}),
      );
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(
        jsonEncode({'message': 'Cadastro realizado com Suceso'}),
      );
    } on UserExistsException {
      return Response(
        400,
        body: jsonEncode({'message': 'Usuario ja cadastrado'}),
      );
    } catch (e, s) {
      log.error('Erro ao cadastrar usuario', e, s);
      return Response.internalServerError();
    }
  }

  @Route('PATCH', '/confirm')
  Future<Response> confirmLogin(Request request) async {
    final user = int.parse(request.headers['user']!);
    final token = JwtHelpers.generateJWT(user).replaceAll('Bearer ', '');
    final inputModel = UserConfirmInputModel(
      userId: user,
      accessToken: token,
      data: await request.readAsString(),
    );
    final refreshToken = await userService.confirmLogin(inputModel);

    return Response.ok(jsonEncode({
      'access_token': 'Bearer $token',
      'refresh_token': refreshToken,
    }));
  }
}
