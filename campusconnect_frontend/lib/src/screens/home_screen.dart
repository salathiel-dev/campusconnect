import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o SharedPreferences
import '../models/produto.dart';
import '../services/produto_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Produto>> _futureProdutos;

  @override
  void initState() {
    super.initState();
    _futureProdutos = ProdutoService.buscarProdutos();
  }

  // Função para fazer logout
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Remove o token

    if (mounted) {
      // Navega de volta para a tela de login, limpando o histórico
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color lightGray = Color(0xFFF0F2F5);
    const Color errorRed = Color(0xFFE53E3E);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('CampusConnect', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          // Adiciona o botão de logout na barra superior
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: FutureBuilder<List<Produto>>(
        future: _futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: errorRed, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Erro ao Carregar Produtos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _futureProdutos = ProdutoService.buscarProdutos();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            final produtos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(produto.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text('Vendido por: ${produto.nomeVendedor}'),
                    trailing: Text('R\$ ${produto.preco.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-product');
        },
        backgroundColor: ufrBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}
