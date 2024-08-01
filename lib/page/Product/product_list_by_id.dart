import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Product/productdetailwidget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api.dart';
import '../../model/product.dart';

class ProductListById extends StatefulWidget {
  final int categoryId;

  const ProductListById({super.key, required this.categoryId});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListByIdState createState() => _ProductListByIdState();
}

class _ProductListByIdState extends State<ProductListById> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _getProductsByCategory();
  }

  Future<List<Product>> _getProductsByCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return APIRepository().getProductByCategoryId(
      widget.categoryId.toString(),
      prefs.getString('accountID').toString(),
      prefs.getString('token') ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load products: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailWidget(product: product),
                      ),
                    );
                  },
                  subtitle: Row(
                    children: [
                      if (product.imageUrl.isNotEmpty &&
                          product.imageUrl != 'Null')
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: Image.network(
                            product.imageUrl,
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                product.imageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      color: Colors.red);
                                },
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16.0),
                            Text(
                              'Giá: ${NumberFormat('#,##0').format(product.price)}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
