import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid || Platform.isIOS) {
      return 'http://localhost:8081'; // 'https://campusconnect-api-ufr-52a53500c2c2.herokuapp.com'; // 'http://localhost:8081'
    } else {
      return 'http://localhost:8081'; // 'https://campusconnect-api-ufr-52a53500c2c2.herokuapp.com';
    }
  }

  static const Duration _timeout = Duration(seconds: 30);

  // Metodo para login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'senha': password,
        }),
      ).timeout(_timeout);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? 'Erro no login',
        };
      }
    } on SocketException {
      return {
        'success': false,
        'error': 'Não foi possível conectar ao servidor. Por favor, verifique a sua conexão à internet e tente novamente.',
      };
    } catch (error) {
      return {
        'success': false,
        'error': 'Ocorreu um erro inesperado. Tente novamente mais tarde.',
      };
    }
  }

  // Metodo para testar conexão com o servidor
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/actuator/health');
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nomeCompleto,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nomeCompleto': nomeCompleto,
          'email': email,
          'senha': password,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'error': responseData['message'] ?? 'Erro desconhecido no cadastro.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Não foi possível conectar ao servidor. Tente novamente.',
      };
    }
  }
}
