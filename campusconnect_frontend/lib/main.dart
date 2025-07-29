import 'package:flutter/material.dart';
import 'src/screens/add_product_screen.dart';
import 'src/screens/chat_list_screen.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/product_detail_screen.dart';
import 'src/screens/profile_screen.dart';
import 'src/screens/splash_screen.dart';

void main() {
  // A configuração de HttpOverrides pode ser necessária para o APK final,
  // mas pode ser comentada durante o desenvolvimento local se não houver problemas de SSL.
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        // Define um tema global para os TextFormFields para um visual mais limpo
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0EFFF)), // soft-blue
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0EFFF)), // soft-blue
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      // A rota inicial é a SplashScreen, que decide para onde ir.
      initialRoute: '/',
      // Rotas que não precisam de argumentos
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/chat-list': (context) => const ChatListScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      // Gerador de rotas para telas que precisam receber argumentos
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(produtoId: productId);
            },
          );
        }
        if (settings.name == '/chat') {
          final conversaId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ChatScreen(conversaId: conversaId);
            },
          );
        }
        // Se a rota não for encontrada, pode retornar uma tela de erro
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
