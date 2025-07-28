import 'package:flutter/material.dart';
import 'src/screens/network_test_screen.dart'; // Importa a nossa nova tela de teste

void main() {
  // A nossa configuração de HttpOverrides ainda é importante
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste de Conexão',
      // Abre diretamente na tela de teste
      home: const NetworkTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
