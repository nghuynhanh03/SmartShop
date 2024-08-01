// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Account/detailuser.dart';
import 'package:flutter_application_smartshop/page/Account/unloginwidget.dart';
import 'package:flutter_application_smartshop/page/loadingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
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
              ? const DetailUser()
              : const Unloginwidget(),
    );
  }
}
