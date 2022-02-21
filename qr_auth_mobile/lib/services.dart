import 'package:dio/dio.dart';

import 'constants.dart';
import 'models/qr_session_model.dart';

class Services {
  static final dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<void> authenticateQRSession(QRSession session) async {
    await dio.put(
      '/authenticateQRSession',
      data: session.toJson(),
    );
  }

  static Future<void> signup(String email, String password) async {
    await dio.post(
      '/signup',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  static Future<bool> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    if (response.data == '1') {
      return true;
    } else {
      return false;
    }
  }
}
