import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

import '../../data/api.dart';
import '../../model/user.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  User user = User.userEmpty();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  Future<void> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    _fullNameController.text = user.fullName ?? '';
    _genderController.text = user.gender ?? '';
    _birthDayController.text = user.birthDay ?? '';
    _phoneNumberController.text = user.phoneNumber ?? '';
    _imageController.text = user.imageURL ?? '';
    // _emailController.text = user.idNumber ?? '';
    setState(() {});
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token not found");
      }
      user.fullName = _fullNameController.text;
      user.gender = _genderController.text;
      user.birthDay = _birthDayController.text;
      user.phoneNumber = _phoneNumberController.text;
      bool result = await APIRepository().updateProfile(user, token);

      Flushbar(
        title: "Cập nhật hồ sơ",
        message:
            result ? "Cập nhật hồ sơ thành công" : "Cập nhật hồ sơ thất bại",
        duration: const Duration(seconds: 3),
      ).show(context);

      if (result) {
        logOut(context);
      }
    } catch (e) {
      Flushbar(
        title: "Cập nhật hồ sơ",
        message: "Cập nhật hồ sơ thất bại: $e",
        duration: const Duration(seconds: 3),
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa hồ sơ'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 75, // Bán kính hình tròn
              backgroundImage:
                  user.imageURL != null && user.imageURL!.isNotEmpty
                      ? NetworkImage(user.imageURL!)
                      : null,
              child: user.imageURL == null || user.imageURL!.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 75, // Kích thước icon nếu không có hình ảnh
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                hintText: 'Tên đầy đủ...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(
                hintText: 'Giới tính...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _birthDayController,
              decoration: InputDecoration(
                hintText: 'Ngày sinh...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Số điện thoại...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Lưu',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
