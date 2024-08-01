import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/page/Profile/editprofilewidget.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage(
                          'assets/images/image.png'), // Path to the avatar image
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Túc Quốc Công',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Set text color to contrast with the background
                          ),
                        ),
                        Text(
                          'Thành viên',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[
                                300], // Adjust text color to contrast with the background
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors
                            .white, // Icon color to contrast with the background
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
                // Xử lý sự kiện khi nhấn vào mục
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
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Xử lý sự kiện khi nhấn vào mục
              },
            ),
          ],
        ),
      ),
    );
  }
}
