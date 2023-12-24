import 'package:flutter/material.dart';
import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/data/local/app_share_preference.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
                AppConstant.SPLASH_ANIMATION_ASSETS,
                animate: true,
                onLoaded: (composition) {
                  Future.delayed(const Duration(seconds: 2), () {
                    String token = AppSharePreference.getString(AppConstant.TOKEN_KEY);
                    if (token.isNotEmpty) {
                      Navigator.pushReplacementNamed(context, "/product");
                    } else {
                      Navigator.pushReplacementNamed(context, "/sign-in");
                    }
                  });
                }
            ),
            const Text("Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white))
          ],
        ));
  }
}
