import 'dart:async';

import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/app_response_dto.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/cart_dto.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/product_dto.dart';

class CartRepository {
  ApiService? _apiService;

  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  Future<CartDTO> addToCartService(String idProduct) async {
    Completer<CartDTO> completer = Completer();
    _apiService
        ?.requestAddToCart(idProduct)
        .then((dataResponse) {
          if (dataResponse.data == null || dataResponse.data == "") {
            completer.complete(CartDTO());
          } else {
            var appResponseUserDTO = AppResponseDTO<CartDTO>.fromJSON(dataResponse.data, CartDTO.fromJson);
            completer.complete(appResponseUserDTO.data);
          }
        })
        .catchError((error) {
          completer.completeError(error.response?.data["message"] ?? error.toString());
        });
    return completer.future;
  }

  Future<CartDTO> getCartProductService() async {
    Completer<CartDTO> completer = Completer();
    _apiService
        ?.requestCartProduct()
        .then((dataResponse) {
      if (dataResponse.data == null || dataResponse.data == "") {
        completer.complete(CartDTO());
      } else {
        var appResponseUserDTO = AppResponseDTO<CartDTO>.fromJSON(dataResponse.data, CartDTO.fromJson);
        completer.complete(appResponseUserDTO.data);
      }
    })
        .catchError((error) {
      completer.completeError(error.response?.data["message"] ?? error.toString());
    });
    return completer.future;
  }

  Future<CartDTO> updateToCartService(String idProduct, String idCart, num quantity) async {
    Completer<CartDTO> completer = Completer();
    _apiService
      ?.requestUpdateToCart(idProduct, idCart, quantity)
      .then((dataResponse) {
        if (dataResponse.data == null || dataResponse.data == "") {
          completer.complete(CartDTO());
        } else {
          var appResponseUserDTO = AppResponseDTO<CartDTO>.fromJSON(dataResponse.data, CartDTO.fromJson);
          completer.complete(appResponseUserDTO.data);
        }
      })
      .catchError((error) {
        completer.completeError(error.response?.data["message"] ?? error.toString());
      });
    return completer.future;
  }
}