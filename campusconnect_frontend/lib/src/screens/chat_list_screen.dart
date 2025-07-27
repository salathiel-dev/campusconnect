import 'package:flutter/material.dart';
import '../models/conversa.dart';
import '../services/chat_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<Conversa>> _futureConversas;

  @override
  void initState() {
    super.initState();
    _futureConversas = ChatService.listarConversas();
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color lightGray = Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('Minhas Conversas', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Conversa>>(
        future: _futureConversas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar conversas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma conversa encontrada.'));
          }

          final conversas = snapshot.data!;
          return ListView.builder(
            itemCount: conversas.length,
            itemBuilder: (context, index) {
              final conversa = conversas[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(conversa.nomeOutroParticipante, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(conversa.ultimaMensagem, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed('/chat', arguments: conversa.idConversa);
                },
              );
            },
          );
        },
      ),
    );
  }
}
