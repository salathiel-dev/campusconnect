import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produto.dart';
import '../models/produto_detalhado.dart';
import './api.dart';

class ProdutoService {
  // static const String baseUrl = 'https://campusconnect-api-ufr-52a53500c2c2.herokuapp.com';
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

    final url = Uri.parse('${ApiService.baseUrl}/products');
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

  static Future<ProdutoDetalhado> cadastrarProduto({
    required String titulo,
    required String descricao,
    required double preco,
    required String categoria,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('${ApiService.baseUrl}/products');
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
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return ProdutoDetalhado.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao cadastrar o produto. Status: ${response.statusCode}');
    }
  }

  static Future<void> uploadImage(String produtoId, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('${ApiService.baseUrl}/products/$produtoId/upload-image');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Falha ao fazer o upload da imagem. Status: ${response.statusCode}');
    }
  }

  static Future<ProdutoDetalhado> buscarProdutoPorId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Utilizador não autenticado.');
    }

    final url = Uri.parse('${ApiService.baseUrl}/products/$id');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return ProdutoDetalhado.fromJson(responseData);
    } else {
      throw Exception('Falha ao carregar os detalhes do produto. Status: ${response.statusCode}');
    }
  }

  static Future<void> atualizarProduto({
    required String id,
    required String titulo,
    required String descricao,
    required double preco,
    required String categoria,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('${ApiService.baseUrl}/products/$id');

    final response = await http.put(
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

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar o produto. Status: ${response.statusCode}');
    }
  }

  static Future<void> excluirProduto(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('${ApiService.baseUrl}/products/$id');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir o produto. Status: ${response.statusCode}');
    }
  }
}

