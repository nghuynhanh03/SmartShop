import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Account/accountwidget.dart';
import 'package:flutter_application_smartshop/page/Cart/cartwidget.dart';
//import 'package:flutter_application_smartshop/page/Categories/category_page.dart';
import 'package:flutter_application_smartshop/page/Categories/categorywidget.dart';
import 'package:flutter_application_smartshop/page/Favorite/favorite.dart';

import 'package:flutter_application_smartshop/page/Home/homewidget.dart';

import '../model/user.dart';
//import 'package:flutter_application_smartshop/page/Profile/profilewidget.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeWidget(),
    const Categorywidget(),
    const Cartwidget(),
    const FavoriteWidget(),
    const AccountWidget()
  ];
  static const List<String> _appBarTitles = [
    "Trang chủ",
    "Phân loại",
    "Giỏ hàng",
    "Danh sách yêu thích",
    "Trang cá nhân"
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: Text(
                _appBarTitles[_selectedIndex],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: false),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Phân loại"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Giỏ hàng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Yêu thích"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded), label: "Cá nhân"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onTapped,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
