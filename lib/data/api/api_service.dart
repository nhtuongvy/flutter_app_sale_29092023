import 'package:dio/dio.dart';
import 'package:flutter_app_sale_29092023/data/api/dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.getInstance().getDio();

  Future<Response<dynamic>> requestSignIn(String email, String password) {
    return _dio.post("user/sign-in", data: {
      "email": email,
      "password": password,
    });
  }

  Future<Response<dynamic>> requestSignUp(
      String email,
      String password,
      String name,
      String phone,
      String address
    ) {
    return _dio.post("user/sign-up", data: {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
      "address": address,
    });
  }

  Future<Response<dynamic>> requestListProduct() {
    return _dio.get("product");
  }

  Future<Response<dynamic>> requestAddToCart(String idProduct) {
    return _dio.post("cart/add", data: {
      "id_product": idProduct,
    });
  }

  Future<Response<dynamic>> requestCartProduct() {
    return _dio.get("cart");
  }

  Future<Response<dynamic>> requestUpdateToCart(String idProduct, String idCart, num quantity) {
    return _dio.post("cart/update", data: {
      "id_product" : idProduct,
      "id_cart" : idCart,
      "quantity" : quantity
    });
  }
}