// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bill.dart';
import '../model/cart.dart';
import '../model/category.dart';
import '../model/product.dart';
import '../model/signup.dart';
import '../model/user.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Future<String> register(Signup user) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final tokenData = res.data['data']['token'];
        print("ok login");
        prefs.setString('token', tokenData);
        prefs.setString('accountID', accountID);
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Category>> getCategory(String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Category/getList?accountID=21DH114505',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => Category.fromJson(e))
          .cast<Category>()
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<bool> addCategory(
      Category data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': '21DH114505'
      });
      Response res = await api.sendRequest.post('/addCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateCategory(
      int categoryID, Category data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': categoryID,
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': '21DH114505'
      });
      Response res = await api.sendRequest.put('/updateCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeCategory(
      int categoryID, String accountID, String token) async {
    try {
      final body = FormData.fromMap(
          {'categoryID': categoryID, 'accountID': '21DH114505'});
      Response res = await api.sendRequest.delete('/removeCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<Product>> getProduct(String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getList?accountID=21DH114505',
          options: Options(headers: header(token)));
      return res.data.map((e) => Product.fromJson(e)).cast<Product>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<Product>> getProductAdmin(String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getListAdmin?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data.map((e) => Product.fromJson(e)).cast<Product>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addProduct(Product data, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'CategoryID': data.categoryId
      });
      Response res = await api.sendRequest.post('/addProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateProduct(
      Product data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': data.id,
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'categoryID': data.categoryId,
        'accountID': accountID
      });

      Response res = await api.sendRequest.put('/updateProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeProduct(
      int productID, String accountID, String token) async {
    try {
      final body =
          FormData.fromMap({'productID': productID, 'accountID': accountID});
      Response res = await api.sendRequest.delete('/removeProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addBill(List<Cart> products, String token) async {
    var list = [];
    try {
      for (int i = 0; i < products.length; i++) {
        list.add({
          'productID': products[i].productID,
          'count': products[i].count,
        });
      }
      Response res = await api.sendRequest.post('/Order/addBill',
          options: Options(headers: header(token)), data: list);
      if (res.statusCode == 200) {
        print("add bill ok");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<Bill>> getHistory(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Bill/getHistory', options: Options(headers: header(token)));
      return res.data.map((e) => Bill.fromJson(e)).cast<Bill>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillDetail>> getHistoryDetail(String billID, String token) async {
    try {
      Response res = await api.sendRequest.post('/Bill/getByID?billID=$billID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => BillDetail.fromJson(e))
          .cast<BillDetail>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> forgetPassword(
      String accountID, String numberID, String newPass) async {
    try {
      final body = FormData.fromMap({
        "accountID": accountID,
        "numberID": numberID,
        "newPass": newPass,
      });

      Response res = await api.sendRequest.put(
        '/Auth/forgetPass',
        options: Options(headers: header('no token')),
        data: body,
      );
      // Kiểm tra response từ API
      if (res.statusCode == 200) {
        print("Password reset successful");
        return "Password reset successful";
      } else {
        String errorMessage =
            "Password reset failed with status code: ${res.statusCode}";
        if (res.data != null &&
            res.data is Map<String, dynamic> &&
            res.data['message'] != null) {
          errorMessage += ", message: ${res.data['message']}";
        }
        print(errorMessage);
        return errorMessage;
      }
    } catch (ex) {
      print("Exception occurred: $ex");
      return "Password reset failed: $ex";
    }
  }

  Future<List<Product>> getProductByCategoryId(
      String categoryID, String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
        '/Product/getListByCatId?categoryID=$categoryID&accountID=21DH114505',
        options: Options(headers: header(token)),
      );
      if (res.statusCode == 200) {
        return List<Product>.from(
          res.data.map((e) => Product.fromJson(e)),
        );
      } else {
        throw Exception('Failed to load products');
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateProfile(User user, String token) async {
    try {
      final body = FormData.fromMap({
        "numberID": user.idNumber,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageURL,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": '2024',
        "schoolKey": 'K27',
      });

      Response res = await api.sendRequest.put(
        '/Auth/updateProfile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: body,
      );

      if (res.statusCode == 200) {
        print("ok");
        return true;
      } else {
        print("fail");
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> changePassword(
      String oldPass, String newpass, String confirmPass, String token) async {
    try {
      final body = FormData.fromMap({
        "OldPassword": oldPass,
        "NewPassword": newpass,
      });

      Response res = await api.sendRequest.put(
        '/Auth/ChangePassword',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: body,
      );
      // Kiểm tra response từ API
      if (res.statusCode == 200) {
        return "Password reset successful";
      } else {
        String errorMessage = "Change password failed.";
        print(errorMessage);
        return errorMessage;
      }
    } catch (ex) {
      return "Change password failed.";
    }
  }
}
