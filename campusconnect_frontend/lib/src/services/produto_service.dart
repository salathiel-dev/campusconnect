import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produto.dart'; // Garanta que este caminho está correto

class ProdutoService {
  // CORREÇÃO: Alterado de 10.0.2.2 para localhost
  static const String baseUrl = 'http://localhost:8081';
  static const Duration timeoutDuration = Duration(seconds: 15);

  static Future<List<Produto>> buscarProdutos() async {
    print('--- Iniciando busca de produtos ---');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      print('[ERRO] Token não encontrado no SharedPreferences.');
      throw Exception('Token não encontrado. O utilizador não está autenticado.');
    }

    print('[DEBUG] Token encontrado: ${token.substring(0, 15)}...');

    final url = Uri.parse('$baseUrl/products');
    print('[DEBUG] A fazer requisição GET para: $url');

    var client = http.Client();
    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeoutDuration);

      print('[DEBUG] Resposta do servidor recebida com Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('[SUCESSO] Produtos recebidos com sucesso.');
        final responseData = json.decode(response.body);
        final List<dynamic> productListJson = responseData['content'];
        return productListJson.map((json) => Produto.fromJson(json)).toList();
      } else {
        print('[ERRO] Falha ao carregar produtos. Corpo da resposta: ${response.body}');
        throw Exception('Falha ao carregar os produtos. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERRO FATAL] Exceção capturada ao buscar produtos: ${e.toString()}');
      throw Exception('Erro de conexão ao buscar produtos: ${e.toString()}');
    } finally {
      client.close();
      print('--- Fim da busca de produtos ---');
    }
  }

  static Future<void> cadastrarProduto({
    required String titulo,
    required String descricao,
    required double preco,
    required String categoria,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Utilizador não autenticado.');
    }

    final url = Uri.parse('$baseUrl/products');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'titulo': titulo,
        'descricao': descricao,
        'preco': preco,
        'categoria': categoria,
      }),
    ).timeout(timeoutDuration);

    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar o produto. Status: ${response.statusCode}');
    }
  }
}
