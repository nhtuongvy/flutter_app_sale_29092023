import 'package:flutter_app_sale_29092023/data/api/dto/product_dto.dart';

class CartDTO {
  String? id;
  List<ProductDTO>? listProductDTO;
  String? idUser;
  num? price;

  CartDTO();

  CartDTO.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    listProductDTO = ProductDTO.convertJson(json["products"]);
    idUser = json["id_user"];
    price = json["price"];
  }
}