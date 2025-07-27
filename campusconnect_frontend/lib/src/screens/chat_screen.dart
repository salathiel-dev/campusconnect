import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/mensagem.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  final String conversaId;

  const ChatScreen({super.key, required this.conversaId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Mensagem> _mensagens = [];
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  String? _currentUserId;

  StompClient? stompClient;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
     final results = await Future.wait([
        AuthService.getUserIdFromToken(),
        ChatService.listarMensagens(widget.conversaId),
      ]);

      setState(() {
        _currentUserId = results[0] as String?;
        _mensagens.addAll(results[1] as List<Mensagem>);
        _isLoading = false;
      });

      _setupStompClient();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Tenho que tratar o erro depois
    }
  }

  void _setupStompClient() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8081/ws',
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient!.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    stompClient!.subscribe(
      destination: '/topic/chats/${widget.conversaId}',
      callback: (frame) {
        if (frame.body != null) {
          final novaMensagem = Mensagem.fromJson(json.decode(frame.body!));
          setState(() {
            _mensagens.insert(0, novaMensagem);
          });
          _scrollToBottom();
        }
      },
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty && stompClient != null && stompClient!.connected) {
      stompClient!.send(
        destination: '/app/chat.sendMessage',
        body: json.encode({
          'conversaId': widget.conversaId,
          'conteudo': content,
        }),
      );
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color lightGray = Color(0xFFF0F2F5);
    const Color interactiveBlue = Color(0xFF3A86FF);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[index];
                // ---> Assumo aqui que o `idRemetente` é o e-mail. <---- Preciso alterar isso.
                final bool isMe = mensagem.idRemetente == _currentUserId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? interactiveBlue : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mensagem.conteudo,
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          // Campo de input para novas mensagens
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: interactiveBlue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
