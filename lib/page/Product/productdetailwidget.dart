// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/model/cart.dart';
import 'package:flutter_application_smartshop/model/favorite.dart';
import 'package:flutter_application_smartshop/page/mainpage.dart';
import '../../data/sqlite.dart';
import 'package:flutter_application_smartshop/model/product.dart';

class ProductDetailWidget extends StatefulWidget {
  final Product product;

  const ProductDetailWidget({super.key, required this.product});

  @override
  _ProductDetailWidgetState createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  bool isFavorite = false;
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    bool favoriteStatus = await dbHelper.isFavorite(widget.product.id);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  Future<void> _toggleFavorite(Product pro) async {
    try {
      if (isFavorite) {
        await dbHelper.removeFavorite(pro.id); // Implement removeFavorite
      } else {
        await dbHelper.addFavorite(Favorite(
          productID: pro.id,
          name: pro.name,
          des: pro.description,
          price: pro.price,
          img: pro.imageUrl,
        ));
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      // Handle error or show feedback
    }
  }

  Future<void> _onSave(Product pro) async {
    await dbHelper.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.product.imageUrl.isNotEmpty &&
                widget.product.imageUrl != 'Null')
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Image.network(
                  widget.product.imageUrl,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      widget.product.imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    );
                  },
                ),
              )
            else
              Container(
                height: 150,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 248,
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: IconButton(
                    onPressed: () => _toggleFavorite(widget.product),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  '${widget.product.price}đ',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${widget.product.price + 100000}đ',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Thông số kỹ thuật',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              formatDescription(
                  widget.product.description, widget.product.categoryName),
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Add action for "Mua hàng" button
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text('Mua hàng'),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _onSave(widget.product);
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const Mainpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text('Thêm vào giỏ hàng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDescription(String description, String cate) {
    final Map<String, dynamic> data = json.decode('{$description}');

    // Tạo chuỗi định dạng
    String formattedDescription = '';

    // Định nghĩa từ điển dịch cho từng loại sản phẩm
    Map<String, String> keyTranslations;

    if (cate == 'Phone') {
      keyTranslations = {
        'screen': 'Màn hình',
        'os': 'Hệ điều hành',
        'rear_camera': 'Camera sau',
        'front_camera': 'Camera trước',
        'chip': 'Chip',
        'ram': 'RAM',
        'storage': 'Dung lượng lưu trữ',
        'sim': 'SIM',
        'battery': 'Pin, Sạc',
        'brand': 'Hãng',
      };
    } else if (cate == 'Laptop') {
      keyTranslations = {
        'cpu': 'CPU',
        'ram': 'RAM',
        'storage': 'Ổ cứng',
        'display': 'Màn hình',
        'graphics_card': 'Card màn hình',
        'ports': 'Cổng kết nối',
        'operating_system': 'Hệ điều hành',
        'design': 'Thiết kế',
        'dimensions_weight': 'Kích thước, khối lượng',
        'release_year': 'Thời điểm ra mắt',
      };
    } else if (cate == 'Tablet') {
      keyTranslations = {
        'display': 'Màn hình',
        'operating_system': 'Hệ điều hành',
        'chip': 'Chip',
        'ram': 'RAM',
        'storage': 'Dung lượng lưu trữ',
        'rear_camera': 'Camera sau',
        'front_camera': 'Camera trước',
        'battery_charging': 'Pin, Sạc',
      };
    } else if (cate == 'Smartwatch') {
      keyTranslations = {
        'display': 'Màn hình',
        'battery_life': 'Thời gian sử dụng pin',
        'compatibility': 'Tương thích',
        'case_material': 'Chất liệu vỏ',
        'health_features': 'Tính năng sức khỏe',
      };
    } else {
      keyTranslations = {};
    }

    // Tra cứu khóa và chuyển đổi thành tiếng Việt
    data.forEach((key, value) {
      final translatedKey = keyTranslations[key] ?? key;

      // Kiểm tra nếu giá trị là một danh sách
      if (value is List) {
        formattedDescription += '$translatedKey: ${value.join(', ')}\n';
      } else {
        formattedDescription += '$translatedKey: $value\n';
      }
    });

    return formattedDescription;
  }
}
