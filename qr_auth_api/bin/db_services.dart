import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'models/models.dart';

class Database {
  static final usersStore = File('database/usersStore.json');
  static final qrSessionsStore = File('database/qrSessionsStore.json');

  static Response signup(User user) {
    final List<dynamic> data = usersStore.readAsStringSync() == ''
        ? []
        : jsonDecode(usersStore.readAsStringSync());

    final List<User> users = data
        .map((item) => User(
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    if (!users.any((item) => item.email == user.email)) {
      users.add(user);
      usersStore.writeAsString(
        users.map((item) => item.toJson()).toList().toString(),
      );
      return Response.ok('1');
    } else {
      return Response.ok('0');
    }
  }

  static Response login(User user) {
    final List<dynamic> data = usersStore.readAsStringSync() == ''
        ? []
        : jsonDecode(usersStore.readAsStringSync());

    final List<User> users = data
        .map((item) => User(
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    if (users.contains(user)) {
      return Response.ok('1');
    } else {
      return Response.ok('0');
    }
  }

  static Response createQRSession(String id) {
    final List<dynamic> data = qrSessionsStore.readAsStringSync() == ''
        ? []
        : jsonDecode(qrSessionsStore.readAsStringSync());

    final List<QRSession> qrSessions = data
        .map((item) => QRSession(
              id: item['id'],
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    qrSessions.add(QRSession(id: id));
    qrSessionsStore.writeAsString(
      qrSessions.map((item) => item.toJson()).toList().toString(),
    );
    return Response.ok('1');
  }

  static Response getQRSessions(String id) {
    final List<dynamic> data = qrSessionsStore.readAsStringSync() == ''
        ? []
        : jsonDecode(qrSessionsStore.readAsStringSync());

    final List<QRSession> qrSessions = data
        .map((item) => QRSession(
              id: item['id'],
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    return Response.ok(
      qrSessions
          .where((item) => item.id == id)
          .map((item) => item.toJson())
          .toList()
          .toString(),
    );
  }

  static Response authenticateQRSession(QRSession session) {
    final List<dynamic> data = qrSessionsStore.readAsStringSync() == ''
        ? []
        : jsonDecode(qrSessionsStore.readAsStringSync());

    final List<QRSession> qrSessions = data
        .map((item) => QRSession(
              id: item['id'],
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    final matchingSession = qrSessions
        .where((item) => item.id == session.id)
        .map((item) => item)
        .toList();
    if (matchingSession.isNotEmpty) {
      qrSessions.remove(matchingSession.first);
      qrSessions.add(session);
      qrSessionsStore.writeAsString(
          qrSessions.map((item) => item.toJson()).toList().toString());
      return Response.ok('Authenticated user 🔓');
    } else {
      return Response.ok("Didn't authenticate user 🔒");
    }
  }

  static Response deleteQRSession(String id) {
    final List<dynamic> data = qrSessionsStore.readAsStringSync() == ''
        ? []
        : jsonDecode(qrSessionsStore.readAsStringSync());

    final List<QRSession> qrSessions = data
        .map((item) => QRSession(
              id: item['id'],
              email: item['email'],
              password: item['password'],
            ))
        .toList();

    qrSessions.remove(qrSessions
        .where((item) => item.id == id)
        .map((item) => item)
        .toList()
        .first);

    qrSessionsStore.writeAsString(
      qrSessions.map((item) => item.toJson()).toList().toString(),
    );

    return Response.ok('Deleted session 🗑️');
  }
}
