class ProdutoDetalhado {
  final String id;
  final String titulo;
  final String descricao;
  final double preco;
  final String categoria;
  final String status;
  final String nomeVendedor;
  final String idVendedor;

  ProdutoDetalhado({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.status,
    required this.nomeVendedor,
    required this.idVendedor,
  });

  factory ProdutoDetalhado.fromJson(Map<String, dynamic> json) {
    return ProdutoDetalhado(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      categoria: json['categoria'],
      status: json['status'],
      nomeVendedor: json['nomeVendedor'],
      idVendedor: json['idVendedor'],
    );
  }
}
