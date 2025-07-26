import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Configuração de URL baseada na plataforma
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Para emulador Android
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      // Para simulador iOS
      return 'http://localhost:8080';
    } else {
      // Para desktop (Windows, macOS, Linux) e web
      return 'http://localhost:8080';
    }
  }

  static const Duration _timeout = Duration(seconds: 15);

  // Método para login
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
        'error': 'Não foi possível conectar ao servidor. Verifique se:\n'
                '1. O servidor backend está rodando na porta 8080\n'
                '2. Sua conexão de rede está funcionando\n'
                '3. O firewall não está bloqueando a conexão',
      };
    } on http.ClientException {
      return {
        'success': false,
        'error': 'Erro de cliente HTTP. Verifique a configuração do servidor.',
      };
    } catch (error) {
      return {
        'success': false,
        'error': 'Erro inesperado: ${error.toString()}',
      };
    }
  }

  // Método para testar conexão com o servidor
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/health');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}
