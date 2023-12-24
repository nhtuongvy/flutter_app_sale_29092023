import 'package:flutter_app_sale_29092023/data/api/dto/user_dto.dart';
import 'package:flutter_app_sale_29092023/data/model/user.dart';

class UserParser {
  static User parseUserDTO(UserDTO userDTO) {
    return User(
        userDTO.email ?? "",
        userDTO.name ?? "",
        userDTO.phone ?? "",
        userDTO.token ?? ""
    );
  }
}
