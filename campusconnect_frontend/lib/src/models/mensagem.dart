class Mensagem {
  final String idMensagem;
  final String idRemetente;
  final String conteudo;
  final DateTime dataEnvio;

  Mensagem({
    required this.idMensagem,
    required this.idRemetente,
    required this.conteudo,
    required this.dataEnvio,
  });

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    return Mensagem(
      idMensagem: json['idMensagem'],
      idRemetente: json['idRemetente'],
      conteudo: json['conteudo'],
      dataEnvio: DateTime.parse(json['dataEnvio']),
    );
  }
}
