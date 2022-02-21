import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import 'success_screen.dart';
import 'custom_textfield.dart';
import 'services.dart';

const uuid = Uuid();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool authenticated = false;

class _LoginScreenState extends State<LoginScreen> {
  final id = uuid.v4();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    Services.createQRSession(id);
    setState(
      () {
        Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            if (authenticated) {
              timer.cancel();
            } else {
              Services.getQRSession(id).then(
                (session) {
                  if (session != null &&
                      session.email != null &&
                      session.password != null) {
                    Services.login(session.email!, session.password!).then(
                      (isLoggedIn) {
                        if (isLoggedIn) {
                          setState(() {
                            authenticated = true;
                          });
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessScreen(),
                          ),
                        );
                        Services.deleteQRSession(id);
                      },
                    );
                  }
                },
              );
            }
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Log in',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Services.login(
                          emailController.text,
                          passwordController.text,
                        ).then(
                          (isLoggedIn) {
                            if (isLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SuccessScreen(),
                                ),
                              );
                              setState(() {
                                authenticated = true;
                              });
                              Services.deleteQRSession(id);
                            } else {
                              emailController.clear();
                              passwordController.clear();
                            }
                          },
                        );
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 45)),
                        textStyle: MaterialStateProperty.all(Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white)),
                      ),
                      child: const Text('Log in'),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.white,
                elevation: 10,
                child: Center(
                  child: QrImage(
                    data: id,
                    version: QrVersions.auto,
                    size: 250,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
