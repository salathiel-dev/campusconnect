import 'package:flutter/material.dart';
import '../models/produto_detalhado.dart';
import '../services/produto_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String produtoId;

  const ProductDetailScreen({super.key, required this.produtoId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ProdutoDetalhado> _futureProdutoDetalhado;

  @override
  void initState() {
    super.initState();
    _futureProdutoDetalhado = ProdutoService.buscarProdutoPorId(widget.produtoId);
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color lightGray = Color(0xFFF0F2F5);
    const Color darkGray = Color(0xFF2D3748);
    const Color interactiveBlue = Color(0xFF3A86FF);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('Detalhes do Produto', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<ProdutoDetalhado>(
        future: _futureProdutoDetalhado,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Produto não encontrado.'));
          }

          final produto = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder para a imagem do produto
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, color: Colors.grey, size: 50),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  produto.titulo,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkGray),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Descrição',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGray),
                ),
                const SizedBox(height: 8),
                Text(
                  produto.descricao,
                  style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Vendido por',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGray),
                ),
                const SizedBox(height: 8),
                Text(
                  produto.nomeVendedor,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: interactiveBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Enviar Mensagem ao Vendedor'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
