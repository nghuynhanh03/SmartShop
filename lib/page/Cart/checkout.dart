import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/data/api.dart';
import 'package:flutter_application_smartshop/data/sqlite.dart';
import 'package:flutter_application_smartshop/page/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart.dart';

class Checkout extends StatefulWidget {
  final List<Cart> cartItems;

  const Checkout({super.key, required this.cartItems});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddressSection(),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ProductListSection(cartItems: widget.cartItems),
            ),
            const SizedBox(height: 10),
            const PaymentMethodSection(),
            const SizedBox(height: 10),
            OrderSummarySection(cartItems: widget.cartItems),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  List<Cart> temp = await _databaseHelper.products();
                  await APIRepository()
                      .addBill(temp, pref.getString('token') ?? '');
                  setState(() {
                    _databaseHelper.clear();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Mainpage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Thanh toán',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Địa chỉ nhận hàng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Công | (+84)901111111'),
            Text('828 Đ. Sư Vạn Hạnh, Phường 12, Quận 10, Hồ Chí Minh'),
          ],
        ),
      ),
    );
  }
}

class ProductListSection extends StatelessWidget {
  final List<Cart> cartItems;

  const ProductListSection({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: cartItems.map((item) {
          return ProductItem(
            imageUrl: item.img,
            name: item.name,
            des: item.des, // Assuming 'des' is used as color here
            price: item.price,
            quantity: item.count,
          );
        }).toList(),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String des;
  final dynamic price;
  final int quantity;

  const ProductItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.des,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(imageUrl, width: 50, height: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mô tả: $des',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Số lượng: x$quantity'),
                ],
              ),
            ),
            Text('${price.toString()}đ'),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.payment),
        title: Text('Phương thức thanh toán'),
        subtitle: Text('Thanh toán khi nhận hàng'),
      ),
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  final List<Cart> cartItems;

  const OrderSummarySection({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    num totalPrice =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.count));

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chi tiết thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            OrderSummaryItem(
                label: 'Tổng thanh toán', value: '$totalPrice đ', isBold: true),
          ],
        ),
      ),
    );
  }
}

class OrderSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const OrderSummaryItem({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
