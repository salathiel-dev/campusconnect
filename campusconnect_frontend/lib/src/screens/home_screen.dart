import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cores para a UI
    const Color lightGray = Color(0xFFF0F2F5);
    const Color ufrBlue = Color(0xFF193866);
    const Color darkGray = Color(0xFF2D3748);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text(
          'CampusConnect',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false, // Remove o botão de "voltar"
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              'Login Realizado com Sucesso!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkGray,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'O feed de produtos aparecerá aqui.',
              style: TextStyle(fontSize: 16, color: darkGray),
            ),
          ],
        ),
      ),
    );
  }
}
