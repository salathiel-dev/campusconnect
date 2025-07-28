import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkTestScreen extends StatefulWidget {
  const NetworkTestScreen({super.key});

  @override
  State<NetworkTestScreen> createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  String _status = 'Aguardando o teste...';
  bool _isLoading = false;

  Future<void> _runTest() async {
    setState(() {
      _isLoading = true;
      _status = 'A testar a conexão...';
    });

    try {
      // Vamos tentar conectar-nos a um servidor público de teste (JSONPlaceholder)
      final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        setState(() {
          _status = 'SUCESSO!\n\nA aplicação conseguiu conectar-se à internet.\n\nO problema está na comunicação específica com o servidor Heroku.';
        });
      } else {
        setState(() {
          _status = 'FALHA!\n\nA aplicação conectou-se, mas recebeu um erro do servidor.\nStatus: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'FALHA CRÍTICA!\n\nA aplicação NÃO conseguiu conectar-se à internet.\n\nO problema é externo (rede, firewall, DNS).\n\nErro: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Conexão de Rede')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _runTest,
                child: const Text('Iniciar Teste de Conexão'),
              ),
              const SizedBox(height: 30),
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
