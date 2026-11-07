import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<ProductProvider>(context, listen: false).fetchProducts()
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    // Filter produk berdasarkan pencarian (Search)
    List<Product> filteredProducts = productProvider.products.where((product) {
      return product.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Tema Pastel Pink
     appBar: AppBar(
  title: const Text('Iren Store Catalog'),
  backgroundColor: const Color(0xFFFFB6C1),
),
      body: Column(
        children: [
          // Widget Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // List Produk
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const Center(child: Text('Produk tidak ditemukan'))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                              title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('\$${product.price.toString()}'),
                              onTap: () {
                                // Navigasi ke Halaman Detail
                                context.push('/detail', extra: product);
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.pinkAccent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus Produk'),
                                      content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(ctx);
                                            await Provider.of<ProductProvider>(context, listen: false)
                                                .deleteProduct(product.id);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Produk berhasil dihapus')),
                                              );
                                            }
                                          },
                                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      // Tombol Tambah Produk (Create)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF69B4),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigasi ke Halaman Tambah Produk (Pastikan rute '/add' sudah terdaftar di main.dart)
          context.push('/add');
        },
      ),
    );
  }
}