import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Favorite/favoritewidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../Account/unloginwidget.dart';
import '../loadingScreen.dart';

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
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

    await Future.delayed(const Duration(seconds: 1));
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
              ? const FavoriteDetail()
              : const Unloginwidget(),
    );
  }
}
