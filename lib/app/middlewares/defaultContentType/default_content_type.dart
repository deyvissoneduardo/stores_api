import 'package:shelf/shelf.dart';
import 'package:stores_api/app/middlewares/middlewares.dart';

class DefaultContentType extends Middlewares {
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);

    return response
        .change(headers: {'content-type': 'application/json;charset=utf-8'});
  }
}
