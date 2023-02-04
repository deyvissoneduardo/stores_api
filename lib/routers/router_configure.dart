import 'package:shelf_router/shelf_router.dart';

import './i_router.dart';

class RouterConfigure implements IRouter {
  final Router _router;
  final List<IRouter> _routers = [];

  RouterConfigure(this._router);

  @override
  void configure(Router router) {
    for (var r in _routers) {
      r.configure(_router);
    }
  }
}
