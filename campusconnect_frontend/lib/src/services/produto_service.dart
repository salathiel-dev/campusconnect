import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campusconnect_frontend/src/models/produto.dart';

class ProdutoService {
  static const String baseUrl = 'http://10.0.2.2:8081';
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<List<Produto>> buscarProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Token não encontrado. O utilizador não está autenticado.');
    }

    final url = Uri.parse('http://10.0.2.2:8081/products');
    var client = http.Client();

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> productListJson = responseData['content'];
        return productListJson.map((json) => Produto.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os produtos. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar produtos: $e');
    } finally {
      client.close();
    }
  }

  // Método para testar conectividade
  static Future<bool> testarConexao() async {
    try {
      final url = Uri.parse('$baseUrl/actuator/health');
      final response = await http.get(url).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      print('Teste de conexão falhou: $e');
      return false;
    }
  }
}
