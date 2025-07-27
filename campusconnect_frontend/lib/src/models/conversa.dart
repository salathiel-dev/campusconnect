class Conversa {
  final String idConversa;
  final String tituloProduto;
  final String nomeOutroParticipante;
  final String ultimaMensagem;
  final DateTime dataUltimaMensagem;

  Conversa({
    required this.idConversa,
    required this.tituloProduto,
    required this.nomeOutroParticipante,
    required this.ultimaMensagem,
    required this.dataUltimaMensagem,
  });

  factory Conversa.fromJson(Map<String, dynamic> json) {
    return Conversa(
      idConversa: json['idConversa'],
      tituloProduto: json['tituloProduto'],
      nomeOutroParticipante: json['nomeOutroParticipante'],
      ultimaMensagem: json['ultimaMensagem'],
      dataUltimaMensagem: DateTime.parse(json['dataUltimaMensagem']),
    );
  }
}
