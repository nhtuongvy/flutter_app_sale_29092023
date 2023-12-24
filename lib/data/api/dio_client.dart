import 'package:dio/dio.dart';
import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/data/local/app_share_preference.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  Dio? _dio;

  static DioClient getInstance(){
    return _instance;
  }

  DioClient._internal();

  Dio getDio() {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: AppConstant.BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ));

      _dio?.interceptors.add(LogInterceptor());
      _dio?.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        String token = AppSharePreference.getString(AppConstant.TOKEN_KEY);
        options.headers["Authorization"] = "Bearer $token";
        return handler.next(options);
      }));
    }

    return _dio ?? Dio();
  }
}