import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/perfil_usuario.dart';
import 'api.dart';

class ProfileService {
  static Future<PerfilUsuario> buscarMeuPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('${ApiService.baseUrl}/profile/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return PerfilUsuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar o perfil.');
    }
  }
}
