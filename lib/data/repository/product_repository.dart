import 'dart:async';

import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/app_response_dto.dart';
import 'package:flutter_app_sale_29092023/data/api/dto/product_dto.dart';

class ProductRepository {
  ApiService? _apiService;

  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  Future<List<ProductDTO>> getListProductsService() async {
    Completer<List<ProductDTO>> completer = Completer();
    _apiService
        ?.requestListProduct()
        .then((dataResponse) {
          if (dataResponse.data == null || dataResponse.data == "") {
            completer.complete(List.empty());
          } else {
            var appResponseUserDTO = AppResponseDTO<List<ProductDTO>>.fromJSON(dataResponse.data, ProductDTO.convertJson);
            completer.complete(appResponseUserDTO.data);
          }
        })
        .catchError((error) {
          completer.completeError(error.response?.data["message"] ?? error.toString());
        });
    return completer.future;
  }
}