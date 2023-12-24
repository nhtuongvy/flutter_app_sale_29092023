import 'package:flutter_app_sale_29092023/common/base/base_event.dart';

class SignInEvent extends BaseEvent {
  String email, password;

  SignInEvent(this.email, this.password);

  @override
  List<Object?> get props => [];

}

class SignInSuccessEvent extends BaseEvent {

  SignInSuccessEvent();

  @override
  List<Object?> get props => [];

}