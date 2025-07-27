class Produto {
  final String id;
  final String titulo;
  final double preco;
  final String nomeVendedor;

  Produto({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.nomeVendedor,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      titulo: json['titulo'],
      preco: (json['preco'] as num).toDouble(),
      nomeVendedor: json['nomeVendedor'],
    );
  }
}
