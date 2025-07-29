import 'package:flutter/material.dart';
import 'src/screens/add_product_screen.dart';
import 'src/screens/chat_list_screen.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/product_detail_screen.dart';
import 'src/screens/profile_screen.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/register_screen.dart';
import 'src/screens/edit_product_screen.dart';

void main() {
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
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0EFFF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0EFFF)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/chat-list': (context) => const ChatListScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/register': (context) => const RegisterScreen(),
      },
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
        if (settings.name == '/edit-product') {
          final productId = settings.arguments as String;
          return MaterialPageRoute(builder: (context) => EditProductScreen(produtoId: productId));
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
