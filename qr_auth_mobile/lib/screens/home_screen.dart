import 'package:flutter/material.dart';
import 'package:qr_auth_mobile/widgets/scanner_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ScannerBottomSheet(email: email, password: password);
                },
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Successfully logged in!'),
      ),
    );
  }
}
