// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Cart/detailcart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../Account/unloginwidget.dart';
import '../loadingScreen.dart';

class Cartwidget extends StatefulWidget {
  const Cartwidget({super.key});

  @override
  State<Cartwidget> createState() => _CartwidgetState();
}

class _CartwidgetState extends State<Cartwidget> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  User user = User.userEmpty();

  Future<void> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null && strUser.isNotEmpty) {
      setState(() {
        user = User.fromJson(jsonDecode(strUser));
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        user = User.userEmpty();
        _isLoggedIn = false;
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: Loadingscreen())
          : _isLoggedIn
              ? const Detailcart()
              : const Unloginwidget(),
    );
  }
}
