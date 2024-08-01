import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/data/sharepre.dart';
import 'package:flutter_application_smartshop/page/Categories/category_list.dart';
import 'package:flutter_application_smartshop/page/Product/product_list.dart';
import 'package:flutter_application_smartshop/page/loadingScreen.dart';
import 'package:flutter_application_smartshop/page/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../Account/accountwidget.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  @override
  State<AdminWidget> createState() => _AdminWidgetState();
}

class _AdminWidgetState extends State<AdminWidget> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProductList(),
    const CategoryList(),
    const AccountWidget()
  ];
  static const List<String> _appBarTitles = [
    "Quản lý sản phẩm",
    "Quản lý phân loại",
    "Trang cá nhân"
  ];

  void setNavigationState(bool isOnManagementPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnManagementPage', isOnManagementPage);
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  void _navigateToScreen(int index) {
    Navigator.pop(context); // Close the drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitles[_selectedIndex],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 243, 152, 33),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL != null && user.imageURL!.length >= 5
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.imageURL!),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person_2_rounded),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.fullName!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'ID: ${user.idNumber}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Quản lý sản phẩm'),
              onTap: () => _navigateToScreen(0),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Quản lý phân loại'),
              onTap: () => _navigateToScreen(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Trang cá nhân'),
              onTap: () => _navigateToScreen(2),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Về trang chủ'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Loadingscreen()),
                );
                await Future.delayed(const Duration(seconds: 2)).then((_) {
                  setNavigationState(false);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Mainpage()),
                  );
                });
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            if (user.accountId != '')
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  logOut(context);
                },
              ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Sản phẩm"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Phân loại"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded), label: "Cá nhân"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onTapped,
        backgroundColor: Colors.orange,
      ),
    );
  }
}
