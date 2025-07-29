import 'package:flutter/material.dart';
import '../services/api.dart'; // Usaremos o ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      try {
        final result = await ApiService.register(
          nomeCompleto: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          if (result['success']) {
            _showSuccessDialog();
          } else {
            _showErrorDialog('Erro no Cadastro', result['error']);
          }
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Erro Inesperado', e.toString());
        }
      } finally {
        if (mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cadastro Realizado!'),
        content: const Text('A sua conta foi criada com sucesso. Agora você pode fazer o login.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ir para Login'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Fecha o diálogo
              Navigator.of(context).pop(); // Volta para a tela de login
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color interactiveBlue = Color(0xFF3A86FF);
    const Color lightGray = Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: ufrBlue,
        title: const Text('Criar Conta', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira o seu nome.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail Institucional'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, insira o seu e-mail.';
                    if (!value.contains('@ufr.edu.br') && !value.contains('@aluno.ufr.edu.br')) {
                      return 'Por favor, use um e-mail institucional da UFR.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: interactiveBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
