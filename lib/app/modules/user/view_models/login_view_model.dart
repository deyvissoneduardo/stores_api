import 'package:stores_api/app/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String email;
  late String password;

  LoginViewModel(String dataRequest) : super(dataRequest);
  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
