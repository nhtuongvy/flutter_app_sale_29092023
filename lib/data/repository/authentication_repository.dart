import 'dart:async';

import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/app_response_dto.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/user_dto.dart';

class AuthenticationRepository {
  ApiService? _apiService;

  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  Future<UserDTO> executeSignInService(String email, String password) {
    Completer<UserDTO> completer = Completer();
    _apiService
        ?.requestSignIn(email, password)
        .then((dataResponse) {
          if (dataResponse.data == null || dataResponse.data == "") {
            completer.complete(UserDTO());
          } else {
            var appResponseUserDTO = AppResponseDTO<UserDTO>.fromJSON(dataResponse.data, UserDTO.fromJson);
            completer.complete(appResponseUserDTO.data);
          }
        })
        .catchError((error) {
          completer.completeError(error.response?.data["message"] ?? error.toString());
        });

    return completer.future;
  }

  Future<UserDTO> executeSignUpService(
      String email,
      String password,
      String name,
      String phone,
      String address,
  ) {
    Completer<UserDTO> completer = Completer();
    _apiService
        ?.requestSignUp(email, password, name, phone, address)
        .then((dataResponse) {
          if (dataResponse.data == null || dataResponse.data == "") {
            completer.complete(UserDTO());
          } else {
            var appResponseUserDTO = AppResponseDTO<UserDTO>.fromJSON(dataResponse.data, UserDTO.fromJson);
            completer.complete(appResponseUserDTO.data);
          }
        })
        .catchError((error) {
          completer.completeError(error.response?.data["message"] ?? error.toString());
        });

    return completer.future;
  }
}