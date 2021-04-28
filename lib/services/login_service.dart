import 'file:///D:/FlutterProjects/auth_task/lib/model/login_response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  LoginService._();
  static final LoginService _dbProvider = LoginService._();

  factory LoginService() => _dbProvider;

  Future<LoginResponse> onSignIn (final String login, final String password) async {
    final Map<String, String> body = Map<String, String>();
    body['email'] = login;
    body['password'] = password;

    try {
      final http.Response response = await http.post(
        Uri.parse('https://site.ualegion.com/api/v1/security/login'),
        headers: {
          "accept": "application/json",
          "Accept-Language": "en",
          "Authorization": "Bearer",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      final responseCode = response.statusCode;
      if (responseCode == 200) {
        final signInResponse = json.decode(response.body);
        return LoginResponse(token: signInResponse['token'],
            duration: signInResponse['duration']);
      } else if (responseCode == 400) {
        throw Exception('Bad request!');
      } else {
        throw Exception('Something went wrong!');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}