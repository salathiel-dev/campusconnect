import 'package:flutter/material.dart';
import '../models/perfil_usuario.dart';
import '../services/produto_service.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<PerfilUsuario> _futurePerfil;

  @override
  void initState() {
    super.initState();
    _futurePerfil = ProfileService.buscarMeuPerfil();
  }

  void _reloadData() {
    setState(() {
      _futurePerfil = ProfileService.buscarMeuPerfil();
    });
  }

  Future<void> _confirmDelete(String produtoId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem a certeza de que deseja excluir este anúncio? Esta ação não pode ser desfeita.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ProdutoService.excluirProduto(produtoId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anúncio excluído com sucesso!')),
                  );
                  _reloadData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color lightGray = Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<PerfilUsuario>(
        future: _futurePerfil,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar perfil: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Perfil não encontrado.'));
          }

          final perfil = snapshot.data!;

          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                color: Colors.white,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(perfil.nomeCompleto, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(perfil.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Meus Anúncios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),

              if (perfil.meusProdutos.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Você ainda não publicou nenhum anúncio.'),
                ))
              else
                ...perfil.meusProdutos.map((produto) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: ListTile(
                      title: Text(produto.titulo),
                      subtitle: Text('Status: ${produto.status ?? 'N/A'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/edit-product', arguments: produto.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(produto.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          );
        },
      ),
    );
  }
}
