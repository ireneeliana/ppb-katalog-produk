import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'models/product_model.dart';
import 'providers/product_provider.dart';
import 'screens/list_product_screen.dart';
import 'screens/detail_product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/add_product_screen.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ListProductScreen(),
    ),
   GoRoute(
  path: '/detail',
  builder: (context, state) {
    final product = state.extra as Product;
    return DetailProductScreen(product: product);
  },
),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) => EditProductScreen(
        product: state.extra as Product,
      ),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddProductScreen(),
    ),
  ],
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PPB Pastel Pink',
      theme: ThemeData(
        useMaterial3: true,
        // Color Scheme Pastel Pink
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC6FF), // Soft Pastel Pink
          primary: const Color(0xFFFF9ECD),   // Sweet Rose Pink
          secondary: const Color(0xFFFFD6A5), // Light Peach Accent
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5), // Lavender Blush / Powder Pink Background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB7B2), // Soft Coral Pink
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}