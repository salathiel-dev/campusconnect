import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversa.dart';
import '../models/mensagem.dart';

class ChatService {
  static const String baseUrl = 'https://campusconnect-api-ufr-52a53500c2c2.herokuapp.com';
  static const Duration timeoutDuration = Duration(seconds: 15);

  static Future<String> iniciarConversa(String produtoId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('$baseUrl/chats/iniciar');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'produtoId': produtoId}),
    ).timeout(timeoutDuration);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body)['idConversa'];
    } else {
      throw Exception('Falha ao iniciar a conversa.');
    }
  }

  static Future<List<Conversa>> listarConversas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('$baseUrl/chats');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      final List<dynamic> conversasListJson = json.decode(response.body);
      return conversasListJson.map((json) => Conversa.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as conversas.');
    }
  }

  static Future<List<Mensagem>> listarMensagens(String conversaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('$baseUrl/chats/$conversaId/messages');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> mensagensJson = responseData['content'];
      return mensagensJson.map((json) => Mensagem.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar as mensagens.');
    }
  }
}
