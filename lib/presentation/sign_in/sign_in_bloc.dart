import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/common/base/base_bloc.dart';
import 'package:flutter_app_sale_29092023/common/base/base_event.dart';
import 'package:flutter_app_sale_29092023/data/local/app_share_preference.dart';
import 'package:flutter_app_sale_29092023/data/model/user.dart';
import 'package:flutter_app_sale_29092023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/sign_in/sign_in_event.dart';
import 'package:flutter_app_sale_29092023/util/parser/user_parser.dart';

class SignInBloc extends BaseBloc {
  AuthenticationRepository? _repository;

  void setAuthenticationRepo(AuthenticationRepository repository) {
    _repository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch(event.runtimeType) {
      case SignInEvent:
        signIn(event as SignInEvent);
        break;
    }
  }

  void signIn(SignInEvent event) {
    loadingSink.add(true);
    _repository?.executeSignInService(event.email, event.password)
        .then((userDTO) {
            User user = UserParser.parseUserDTO(userDTO);
            if (user.token.isNotEmpty) {
              progressSink.add(SignInSuccessEvent());
              AppSharePreference.setString(key: AppConstant.TOKEN_KEY, value: user.token);
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