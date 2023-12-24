import 'package:flutter_app_sale_29092023/data/api/dto/product_dto.dart';
import 'package:flutter_app_sale_29092023/data/model/product.dart';

class ProductParser {
  static Product parseProductDTO(ProductDTO? productDTO) {
    if (productDTO == null) return Product();
    final Product product = Product();
    product.id = productDTO.id ??= "";
    product.img = productDTO.img ??= "";
    product.name = productDTO.name ??= "";
    product.price = productDTO.price ??= 0;
    product.quantity = productDTO.quantity ??= 0;
    product.gallery = productDTO.gallery ??= List.empty(growable: true);
    product.address = productDTO.address ??= "";
    return product;
  }
}