import 'dart:async';

import 'package:flutter_app_sale_29092023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_29092023/common/base/base_event.dart';
import 'package:flutter_app_sale_29092023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_29092023/data/model/cart.dart';
import 'package:flutter_app_sale_29092023/presentation/cart/cart_event.dart';
import 'package:flutter_app_sale_29092023/util/parser/cart_parser.dart';

class CartBloc extends BaseBloc {
  CartRepository? _cartRepository;

  StreamController<Cart> _cartController = StreamController();

  Stream<Cart> getCartStream() => _cartController.stream;

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case GetCartEvent:
        getCartProduct();
        break;
    }
  }

  void getCartProduct() {
    loadingSink.add(true);
    _cartRepository?.getCartProductService()
      .then((cartDTO) {
        _cartController.add(CartParser.parseFromCartDTO(cartDTO));
      })
      .catchError((error) { messageSink.add(error); })
      .whenComplete(() => loadingSink.add(false));
  }

  @override
  void dispose() {
    super.dispose();
    _cartController.close();
  }

}