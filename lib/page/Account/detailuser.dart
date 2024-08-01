// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/data/sharepre.dart';
import 'package:flutter_application_smartshop/page/Admin/adminwidget.dart';
import 'package:flutter_application_smartshop/page/Bill/historybill.dart';
import 'package:flutter_application_smartshop/page/Profile/changepassword.dart';
import 'package:flutter_application_smartshop/page/Profile/editprofilewidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../loadingScreen.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({super.key});

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  // bool _expanded_user = false;
  // bool _expanded_manager = false;
  bool isOnManagementPage = false;

  @override
  void initState() {
    super.initState();
    getDataUser();
    checkNavigationState();
  }

  void setNavigationState(bool isOnManagementPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnManagementPage', isOnManagementPage);
  }

  checkNavigationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isOnManagementPage = prefs.getBool('isOnManagementPage') ?? false;
    });
  }

  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  TextStyle mystyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: isOnManagementPage ? Colors.orange : Colors.blue,
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      child:
                          (user.imageURL != null && user.imageURL!.isNotEmpty)
                              ? Image.network(
                                  user.imageURL!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: Icon(Icons.person, size: 70),
                                    );
                                  },
                                )
                              : const SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Icon(Icons.person, size: 70),
                                ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.fullName.toString().length > 15 ? '${user.fullName.toString().substring(0, 15)}...' : user.fullName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.idNumber ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileWidget()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Đơn hàng'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryBill(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Đánh giá của tôi'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào mục
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào mục
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: const Text('Chính sách và điều khoản'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào mục
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Hỗ trợ'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào mục
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Thay đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordWidget()),
                );
              },
            ),
            if (user.fullName!.contains('_admin_smart_shop'))
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Quản lý'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Loadingscreen()),
                  );
                  await Future.delayed(const Duration(seconds: 2)).then((_) {
                    Navigator.pop(context);
                    setNavigationState(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminWidget()),
                    );
                  });
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
