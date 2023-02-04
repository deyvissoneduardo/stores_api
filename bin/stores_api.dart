import 'dart:io';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;

Future<void> main(List<String> arguments) async {
  final ip = InternetAddress.anyIPv4;

  final router = Router();

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8181');

  final server = await serve(handler, ip, port);

  print('Server listening on port ${server.port}');
}
