import 'package:flutter_app_sale_29092023/data/api/dto/cart_dto.dart';
import 'package:flutter_app_sale_29092023/data/model/cart.dart';
import 'package:flutter_app_sale_29092023/util/parser/product_parser.dart';

class CartParser {
  static Cart parseFromCartDTO(CartDTO? cartDTO) {
    if (cartDTO == null) return Cart();
    final Cart cart = Cart();
    cart.id = cartDTO.id ?? "";
    cart.idUser = cartDTO.idUser ?? "";
    cart.listProduct = cartDTO.listProductDTO?.map((e) {
      return ProductParser.parseProductDTO(e);
    }).toList() ?? List.empty();
    cart.price = cartDTO.price ?? 0;
    return cart;
  }
}