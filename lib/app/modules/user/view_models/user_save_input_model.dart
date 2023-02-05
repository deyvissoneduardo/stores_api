import 'package:stores_api/app/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String name;
  late String email;
  late String password;

  UserSaveInputModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    name = data['name'];
    email = data['email'];
    password = data['password'];
  }
}
