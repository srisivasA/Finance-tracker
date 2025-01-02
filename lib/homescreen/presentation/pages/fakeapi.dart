import 'dart:convert';

import 'package:Expanses/homescreen/presentation/pages/postmethod_api.dart';
import 'package:Expanses/homescreen/presentation/pages/product_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Grocerys extends StatefulWidget {
  const Grocerys({super.key});

  @override
  State<Grocerys> createState() => _GrocerysState();
}

class _GrocerysState extends State<Grocerys> {
  List<Product> products = [];
  bool isLoading = false;
  final String apiUrl = "https://fakestoreapi.com/products";

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((json) => Product.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery Products'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No Products Found'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to ListProduct screen with the selected product
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListProduct(product: product),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              product.image != null
                                  ? Image.network(
                                      product.image!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      size: 100),
                              const SizedBox(height: 8),
                              Text(
                                product.title ?? 'No Title',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.description ?? 'No Description',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


