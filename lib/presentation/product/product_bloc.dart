import 'dart:async';

import 'package:flutter_app_sale_29092023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_29092023/common/base/base_event.dart';
import 'package:flutter_app_sale_29092023/data/model/cart.dart';
import 'package:flutter_app_sale_29092023/data/model/product.dart';
import 'package:flutter_app_sale_29092023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_29092023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/product/product_event.dart';
import 'package:flutter_app_sale_29092023/util/parser/cart_parser.dart';
import 'package:flutter_app_sale_29092023/util/parser/product_parser.dart';

class ProductBloc extends BaseBloc {
  ProductRepository? _productRepository;
  CartRepository? _cartRepository;
  StreamController<List<Product>> _listProductController = StreamController();
  StreamController<Cart> _cartController = StreamController();

  Stream<List<Product>> getListProductStream() => _listProductController.stream;
  Stream<Cart> getCartStream() => _cartController.stream;

  void setProductRepo(ProductRepository repository) {
    _productRepository = repository;
  }

  void setCartRepo(CartRepository repository) {
    _cartRepository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case GetListProductEvent:
        getListProduct();
        break;
      case AddToCartEvent:
        addToCart(event as AddToCartEvent);
        break;
    }
  }

  void getListProduct() {
    loadingSink.add(true);
    _productRepository?.getListProductsService()
        .then((productDTO) {
          List<Product> listProduct = productDTO.map((e) => ProductParser.parseProductDTO(e)).toList();
          _listProductController.add(listProduct);
        })
        .catchError((error) { messageSink.add(error); })
        .whenComplete(() => loadingSink.add(false));
  }

  void addToCart(AddToCartEvent event) {
    loadingSink.add(true);
    _cartRepository?.addToCartService(event.idProduct)
        .then((cartDTO) {
          Cart cart = CartParser.parseFromCartDTO(cartDTO);
          _cartController.add(cart);
        })
        .catchError((error) { messageSink.add(error); })
        .whenComplete(() => loadingSink.add(false));
  }

  @override
  void dispose() {
    super.dispose();
    _listProductController.close();
  }
}