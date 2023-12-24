import 'package:flutter_app_sale_29092023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_29092023/common/base/base_event.dart';
import 'package:flutter_app_sale_29092023/data/model/user.dart';
import 'package:flutter_app_sale_29092023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/sign_up/sign_up_event.dart';
import 'package:flutter_app_sale_29092023/util/parser/user_parser.dart';

class SignUpBloc extends BaseBloc {
  AuthenticationRepository? _repository;

  void setAuthenticationRepo(AuthenticationRepository repository) {
    _repository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case SignUpEvent:
        signUp(event as SignUpEvent);
        break;
    }
  }

  void signUp(SignUpEvent event) {
    loadingSink.add(true);
    _repository?.executeSignUpService(
            event.email,
            event.password,
            event.name,
            event.phone,
            event.address
        )
        .then((userDTO) {
          User user = UserParser.parseUserDTO(userDTO);
          if (user.email.isNotEmpty) {
            progressSink.add(SignUpSuccess());
          }
        })
        .catchError((error) { messageSink.add(error); })
        .whenComplete(() => loadingSink.add(false));
  }

  @override
  void dispose() {
    super.dispose();
  }
}