import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isServerOnline = false;

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    final isOnline = await ApiService.testConnection();
    setState(() {
      _isServerOnline = isOnline;
    });
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Erro de Validação', 'Por favor, preencha o e-mail e a senha.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      if (result['success']) {
        final token = result['data']['token'];
        _showSuccessDialog('Login Bem-Sucedido!', 'Token: $token');
      } else {
        _showErrorDialog('Erro no Login', result['error']);
      }
    } catch (error) {
      _showErrorDialog('Erro Inesperado', error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  void _showSuccessDialog(String title, String token) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('Autenticação realizada com sucesso!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userToken', token);
              if (!mounted) {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color ufrBlue = Color(0xFF193866);
    const Color interactiveBlue = Color(0xFF3A86FF);
    const Color lightGray = Color(0xFFF0F2F5);
    const Color darkGray = Color(0xFF2D3748);
    const Color mediumGray = Color(0xFFA0AEC0);
    const Color white = Color(0xFFFFFFFF);
    const Color softBlue = Color(0xFFE0EFFF);
    const Color errorRed = Color(0xFFE53E3E);
    const Color successGreen = Color(0xFF38A169);

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Status do servidor
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _isServerOnline ? successGreen.withOpacity(0.1) : errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isServerOnline ? successGreen : errorRed,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isServerOnline ? Icons.check_circle : Icons.error,
                        color: _isServerOnline ? successGreen : errorRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isServerOnline
                            ? 'Servidor conectado (${ApiService.baseUrl})'
                            : 'Servidor offline - Verifique se o backend está rodando',
                          style: TextStyle(
                            color: _isServerOnline ? successGreen : errorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        onPressed: _checkServerConnection,
                        color: _isServerOnline ? successGreen : errorRed,
                      ),
                    ],
                  ),
                ),

                const Text(
                  'CampusConnect',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ufrBlue, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse sua conta na comunidade UFR',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: darkGray, fontSize: 16),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'E-mail Institucional',
                    hintStyle: const TextStyle(color: mediumGray),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: softBlue)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: softBlue)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    hintStyle: const TextStyle(color: mediumGray),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: softBlue)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: softBlue)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: interactiveBlue,
                    foregroundColor: white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text('Esqueci minha senha', style: TextStyle(color: interactiveBlue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
