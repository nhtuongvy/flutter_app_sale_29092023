import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/common/base/base_widget.dart';
import 'package:flutter_app_sale_29092023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_29092023/common/widget/progress_listener_widget.dart';
import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/repository/authentication_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/sign_in/sign_in_bloc.dart';
import 'package:flutter_app_sale_29092023/presentation/sign_in/sign_in_event.dart';
import 'package:flutter_app_sale_29092023/util/dimenstion_util.dart';
import 'package:flutter_app_sale_29092023/util/message_util.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context) => ApiService()),
          ProxyProvider<ApiService, AuthenticationRepository>(
            create: (context) => AuthenticationRepository(),
            update: (context, apiService, repository) {
              repository?.setApiService(apiService);
              return repository ?? AuthenticationRepository();
            },
          ),
          ProxyProvider<AuthenticationRepository, SignInBloc>(
            create: (context) => SignInBloc(),
            update: (context, repository, bloc) {
              bloc?.setAuthenticationRepo(repository);
              return bloc ?? SignInBloc();
            },
          ),
        ],
        appBar: AppBar(
          title: Text("Login"),
        ),
        child: SignInContainer(),
    );
  }
}

class SignInContainer extends StatefulWidget {
  const SignInContainer({super.key});

  @override
  State<SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<SignInContainer> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SignInBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc?.messageStream.listen((event) {
        MessageUtil.showMessage(context, "Alert!!", event.toString());
      });
    });
  }

  void clickSignIn(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _bloc?.messageSink.add("Input is not empty");
      return;
    }
    _bloc?.signIn(SignInEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(
            children: [
              SafeArea(
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: LayoutBuilder(builder: (context, constraint) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Image.asset(AppConstant.IMAGE_BANNER_ASSETS)),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: DimensionUtils.paddingHeightDivideNumber(
                                                  context)),
                                          child: _buildEmailTextField(emailController),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: DimensionUtils.paddingHeightDivideNumber(context)
                                          ),
                                          child: _buildPasswordTextField(passwordController),
                                        ),
                                        _buildButtonSignIn(() {
                                          clickSignIn(emailController.text, passwordController.text);
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: _buildTextSignUp((){
                                   Navigator.pushNamed(context, "/sign-up");
                                }))
                              ],
                            )),
                      ),
                    );
                  }),
                ),
              ),
              LoadingWidget(bloc: _bloc),
              ProgressListenerWidget<SignInBloc>(
                  callback: (event) {
                    if (event is SignInSuccessEvent) {
                      Navigator.pushReplacementNamed(context, "/product");
                    }
                  }
              ),
            ]
        )
    );
  }

  Widget _buildTextSignUp(Function()? onClickSignUp) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account!"),
            InkWell(
              onTap: onClickSignUp,
              child: const Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildEmailTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "Email",
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: const Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        obscureText: true,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          labelStyle: const TextStyle(color: Colors.blue),
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(Function() eventSignIn) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[500];
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.blueAccent;
                  }),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
                )),
            child: ElevatedButton(
              onPressed: eventSignIn,
              child: const Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc?.dispose();
  }
}