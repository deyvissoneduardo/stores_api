import 'dart:io';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:stores_api/app/config/application_config.dart';
import 'package:stores_api/app/middlewares/cors/cors_middlewares.dart';
import 'package:stores_api/app/middlewares/defaultContentType/default_content_type.dart';
import 'package:stores_api/app/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';

Future<void> main(List<String> arguments) async {
  final router = Router();
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  final handler = const shelf.Pipeline()
      .addMiddleware(CorsMiddlewares().handler)
      .addMiddleware(DefaultContentType().handler)
      .addMiddleware(SecurityMiddleware(log: getIt.get()).handler)
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8181');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
