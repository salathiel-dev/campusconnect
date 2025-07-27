import 'src/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/product_detail_screen.dart';
import 'src/screens/chat_list_screen.dart';
import 'src/screens/chat_screen.dart';

void main() {
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
      ),
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
          return MaterialPageRoute(builder: (context) => ChatScreen(conversaId: conversaId));
        }
        return null;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/chat-list': (context) => const ChatListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
