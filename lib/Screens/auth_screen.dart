import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Enums/authMode.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Providers/auth.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.pink,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0, 1]),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 94),
                      transform: Matrix4.rotationZ(-10 * pi / 180)
                        ..translate(-10.8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrange.shade400,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]),
                      child: const Text("My Shop"),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      //Invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        //LoginUser
        await Provider.of<Auth>(context, listen: false)
            .loginUser(_authData['email'], _authData['password']);
      } else {
        //sign up user
        await Provider.of<Auth>(context, listen: false)
            .signUpUser(_authData['email'], _authData['password']);
      }
    } on HttpExceptions catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email adress is already in use";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email adress';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
        errorMessage = 'Wrong email or Password';
      }
      // else if (error.toString().contains('INVALID_PASSWORD')) {
      //   errorMessage = 'Invalid Password';
      // }
      showErrorDialog(context, errorMessage);
    } catch (error) {
      showErrorDialog(context, 'Could not authenticate you please try again');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Singup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: _authMode == AuthMode.Singup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Singup ? 320 : 260,
          minWidth: deviceSize.width * 0.75,
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authData['email'] = newValue!;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "Password is too short ";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authData['password'] = newValue!;
                    },
                  ),
                  if (_authMode == AuthMode.Singup)
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Confirm Password"),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: _authMode == AuthMode.Singup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return "Password do not Match";
                              }
                              return null;
                            }
                          : null,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                      ),
                    ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        "${_authMode == AuthMode.Login ? "SignUp" : " Login"}  Insted"),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}