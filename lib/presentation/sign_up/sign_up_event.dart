import 'package:flutter_app_sale_29092023/common/base/base_event.dart';

class SignUpEvent extends BaseEvent {
  String email, password, name, phone, address;

  SignUpEvent(this.email, this.password, this.name, this.phone, this.address);

  @override
  List<Object?> get props => [];
}


class SignUpSuccess extends BaseEvent {

  @override
  List<Object?> get props => [];
}