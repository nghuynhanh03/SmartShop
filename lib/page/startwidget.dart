import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_application_smartshop/page/Account/loginwidget.dart';
import 'package:flutter_application_smartshop/page/mainpage.dart';

class Startwidget extends StatefulWidget {
  const Startwidget({super.key});

  @override
  State<Startwidget> createState() => _StartwidgetState();
}

class _StartwidgetState extends State<Startwidget> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Mainpage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromARGB(255, 159, 205, 244)
                .withOpacity(0.5), // Lớp màu xanh trắng mờ
          ),
          const Center(
            child: Text(
              "SmartShop",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: Text("HomeScreen"),
      ),
    );
  }
}
