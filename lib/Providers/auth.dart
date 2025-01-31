import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shooping_app/Models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireyDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expireyDate != null &&
        _token != null &&
        _expireyDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse(
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBux1Z-5luWmtBIe8A2DA2HG7yT4eJi-ZQ");
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExceptions(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireyDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUpUser(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }

  Future<void> loginUser(String? email, String? password) async {
    return _authenticate(email!, password!, 'signInWithPassword');
  }

  void logOutUser() async {
    _token = null;
    _expireyDate = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireyDate = expiryDate;
    notifyListeners();
    return true;
  }
}
