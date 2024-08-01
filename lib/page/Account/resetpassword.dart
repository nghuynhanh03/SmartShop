// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../data/api.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _accountIDController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String result = await APIRepository().forgetPassword(
        _accountIDController.text,
        _numberIDController.text,
        _newPasswordController.text,
      );
      Flushbar(
        title: "Đặt lại mật khẩu",
        message: result,
        duration: const Duration(seconds: 3),
      ).show(context);
    } catch (e) {
      Flushbar(
        title: "Đặt lại mật khẩu",
        message: "Thiêt lập lại mật khẩu thất bại: $e",
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
    return AlertDialog(
      title: const Text('Đặt lại mật khẩu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 400,
            child: TextField(
              controller: _accountIDController,
              decoration: InputDecoration(
                hintText: 'Tên đăng nhập...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 400,
            child: TextField(
              controller: _numberIDController,
              decoration: InputDecoration(
                hintText: 'Số ID...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 400,
            child: TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                hintText: 'Mật khẩu mới...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _resetPassword,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Đặt lại mật khẩu'),
        ),
      ],
    );
  }
}
