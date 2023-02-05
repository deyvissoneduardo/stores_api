import 'dart:convert';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:stores_api/app/helpers/jwt_helpers.dart';
import 'package:stores_api/app/logger/i_logger.dart';
import 'package:stores_api/app/middlewares/middlewares.dart';
import 'package:stores_api/app/middlewares/security/security_skip_url.dart';

class SecurityMiddleware extends Middlewares {
  final ILogger _log;
  final skypUrl = <SecuritySkipUrl>[
    SecuritySkipUrl(url: '/auth/', method: 'POST'),
    SecuritySkipUrl(url: '/auth/register', method: 'POST'),
  ];

  SecurityMiddleware({required ILogger log}) : _log = log;

  @override
  Future<Response> execute(Request request) async {
    try {
      if (skypUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }

      final authHeaderContent = authHeader.split(' ');

      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelpers.getClaim(authorizationToken);

      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }

      final claimsMap = claims.toJson();

      final userId = claimsMap['sub'];
      final supplierId = claimsMap['supplier'];

      if (userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
        'supplier': supplierId != null ? '$supplierId' : null
      };

      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      _log.error('Erro ao validar token JWT', e, s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      _log.error('Internal Server Error', e, s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
