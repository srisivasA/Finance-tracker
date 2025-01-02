import 'package:Expanses/homescreen/presentation/pages/product_Viewmodel.dart';
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final Product product;

  const ListProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image != null
                ? Image.network(
                    product.image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 200),
            const SizedBox(height: 16),
            Text(
              product.title ?? 'No Title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              product.description ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


