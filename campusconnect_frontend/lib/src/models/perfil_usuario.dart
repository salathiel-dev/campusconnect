import 'produto.dart';

class PerfilUsuario {
  final String nomeCompleto;
  final String email;
  final List<Produto> meusProdutos;

  PerfilUsuario({
    required this.nomeCompleto,
    required this.email,
    required this.meusProdutos,
  });

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    var listaDeProdutosJson = json['meusProdutos'] as List;
    List<Produto> produtos = listaDeProdutosJson.map((p) => Produto.fromJson(p)).toList();

    return PerfilUsuario(
      nomeCompleto: json['nomeCompleto'],
      email: json['email'],
      meusProdutos: produtos,
    );
  }
}
