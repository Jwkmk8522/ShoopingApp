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
  bool _isVisible = false;
  bool _isVisible2 = false;
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
        height: _authMode == AuthMode.Singup ? 340 : 280,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Singup ? 340 : 280,
          minWidth: deviceSize.width * 0.75,
        ),
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onError,
                            width: 2.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      errorStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    // The color of the text that user enter
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_isVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(_isVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onError,
                            width: 2.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      errorStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),

                    // The color of the text that user enter
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
                  const SizedBox(height: 10),
                  if (_authMode == AuthMode.Singup)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: !_isVisible2,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        hintText: 'Confirm Your Password',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        prefixIcon: Icon(
                          Icons.password,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible2 = !_isVisible2;
                              });
                            },
                            icon: Icon(_isVisible2
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onError,
                              width: 2.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                      ),

                      // The color of the text that user enter
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
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
                    height: 15,
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
                      "${_authMode == AuthMode.Login ? "SignUp" : " Login"}  Insted",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
