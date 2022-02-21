import 'dart:io' show Platform, InternetAddress;

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'db_services.dart';
import 'models/models.dart';

// Configure routes
final _router = Router()
  ..get('/', _rootHandler)
  ..post('/signup', _signupHandler)
  ..post('/login', _loginHandler)
  ..post('/createQRSession/<id>', _createQRSessionHandler)
  ..get('/getQRSessions/<id>', _getQRSessionsHandler)
  ..put('/authenticateQRSession', _authenticateQRSessionHandler)
  ..delete('/deleteQRSession/<id>', _deleteQRSessionHandler);

Response _rootHandler(Request request) {
  return Response.ok('Server is up! 🎉\n');
}

// User Authentication

Future<Response> _signupHandler(Request request) async {
  final User user = User.fromJson(await request.readAsString());
  return Database.signup(user);
}

Future<Response> _loginHandler(Request request) async {
  final User user = User.fromJson(await request.readAsString());
  return Database.login(user);
}

// QR Code Authentication

Future<Response> _createQRSessionHandler(Request request) async {
  final id = request.params['id'] as String;
  return Database.createQRSession(id);
}

Future<Response> _getQRSessionsHandler(Request request) async {
  final id = request.params['id'] as String;
  return Database.getQRSessions(id);
}

Future<Response> _authenticateQRSessionHandler(Request request) async {
  final QRSession session = QRSession.fromJson(await request.readAsString());
  return Database.authenticateQRSession(session);
}

Future<Response> _deleteQRSessionHandler(Request request) async {
  final id = request.params['id'] as String;
  return Database.deleteQRSession(id);
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  // Configure pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server running at:\nhttp://localhost:${server.port}\n');
}
