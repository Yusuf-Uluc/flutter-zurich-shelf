import 'dart:convert';

import 'package:dio/dio.dart';

import 'qr_session_model.dart';

class Services {
  static final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  static Future<QRSession?> getQRSession(String id) async {
    final response = await dio.get('/getQRSessions/$id');

    final List<dynamic> data = jsonDecode(response.data);

    final List<QRSession> qrSessions =
        data.map((item) => QRSession.fromMap((item))).toList();
    if (qrSessions.isEmpty) {
      return null;
    } else {
      return qrSessions.first;
    }
  }

  static Future<void> deleteQRSession(String id) async {
    await dio.delete('/deleteQRSession/$id');
  }

  static Future<void> createQRSession(String id) async {
    await dio.post('/createQRSession/$id');
  }

  static Future<bool> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {
        "email": email,
        "password": password,
      },
    );
    if (response.data == '1') {
      return true;
    } else {
      return false;
    }
  }
}
