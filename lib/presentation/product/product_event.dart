import 'package:flutter_app_sale_29092023/common/base/base_event.dart';

class GetListProductEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends BaseEvent {
  String idProduct;

  AddToCartEvent(this.idProduct);

  @override
  List<Object?> get props => [];
}