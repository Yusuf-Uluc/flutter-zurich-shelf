import 'dart:convert';

class QRSession {
  final String id;
  final String? email;
  final String? password;

  QRSession({
    required this.id,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory QRSession.fromMap(Map<String, dynamic> map) {
    return QRSession(
      id: map['id'] ?? '',
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QRSession.fromJson(String source) =>
      QRSession.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QRSession &&
        other.id == id &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ password.hashCode;
}
