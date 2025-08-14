class Produto {
  final String id;
  final String titulo;
  final double preco;
  final String? nomeVendedor;
  final String? status;
  final String? imageUrl;

  Produto({
    required this.id,
    required this.titulo,
    required this.preco,
    this.nomeVendedor,
    this.status,
    this.imageUrl,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      titulo: json['titulo'],
      preco: (json['preco'] as num).toDouble(),
      nomeVendedor: json['nomeVendedor'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }
}
