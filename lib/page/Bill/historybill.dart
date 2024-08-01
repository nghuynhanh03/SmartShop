// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/model/bill.dart';
import 'package:flutter_application_smartshop/page/Bill/detailbill.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api.dart';

class HistoryBill extends StatefulWidget {
  const HistoryBill({super.key});

  @override
  State<HistoryBill> createState() => _HistoryBillState();
}

class _HistoryBillState extends State<HistoryBill> {
  late Future<List<Bill>> _futureBills;

  @override
  void initState() {
    super.initState();
    _futureBills = _getBills();
  }

  Future<List<Bill>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return APIRepository().getHistory(prefs.getString('token')!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Lịch sử hóa đơn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Bill>>(
        future: _futureBills,
        builder: (context, AsyncSnapshot<List<Bill>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No bills found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemBill = snapshot.data![index];
                return _buildBillWidget(itemBill, context);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildBillWidget(Bill bill, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var billDetail = await APIRepository()
            .getHistoryDetail(bill.id, prefs.getString('token')!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBill(
              id: bill.id,
              total: bill.total,
              bill: billDetail,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã hóa đơn: ${bill.id.length > 10 ? '${bill.id.substring(0, 10)}...' : bill.id}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(bill.total),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Khách hàng: ${bill.fullName}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Ngày tạo: ${bill.dateCreated}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
