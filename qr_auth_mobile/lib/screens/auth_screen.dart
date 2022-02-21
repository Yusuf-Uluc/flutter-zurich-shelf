import 'package:flutter/material.dart';

import '/widgets/index.dart';
import '/services.dart';
import 'index.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authenticate'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Log In'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      controller: loginEmailController,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: loginPasswordController,
                      hintText: 'Enter your Password',
                      labelText: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await Services.login(
                          loginEmailController.text,
                          loginPasswordController.text,
                        ).then(
                          (isLoggedIn) {
                            if (isLoggedIn == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(name: 'Home'),
                                  builder: (context) => HomeScreen(
                                    email: loginEmailController.text,
                                    password: loginPasswordController.text,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 45)),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: signupEmailController,
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: signupPasswordController,
                      hintText: 'Enter your Password',
                      labelText: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Services.signup(
                          signupEmailController.text,
                          signupPasswordController.text,
                        );
                        signupEmailController.clear();
                        signupPasswordController.clear();
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 45)),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
