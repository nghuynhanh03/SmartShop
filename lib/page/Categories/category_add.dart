// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_smartshop/data/api.dart';
import 'package:flutter_application_smartshop/model/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final Category? categoryModel;
  const CategoryAdd({super.key, this.isUpdate = false, this.categoryModel});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  String titleText = "";

  List<String> categoriesImages = [];
  String selectedImage = '';

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imgController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addCategory(
        Category(id: 0, name: name, imageUrl: image, desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    // await _databaseService
    //     .insertCategory(CategoryModel(name: name, desc: description));
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _loadProductImages() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    const productsDir = 'assets/images/categories/';
    categoriesImages = manifestMap.keys
        .where((String key) => key.startsWith(productsDir))
        .toList();
  }

  Future<void> _onUpdate(int id) async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imgController.text;
    var pref = await SharedPreferences.getInstance();

    //update
    await APIRepository().updateCategory(
        id,
        Category(
            id: widget.categoryModel!.id,
            name: name,
            imageUrl: image,
            desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: categoriesImages.length,
              itemBuilder: (context, index) {
                final image = categoriesImages[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _imgController.text = image;
                      selectedImage = image;
                    });
                    Navigator.pop(context);
                  },
                  child: Image.asset(image),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProductImages();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _imgController.text = widget.categoryModel!.imageUrl;
      _descController.text = widget.categoryModel!.desc;
    }
    if (widget.isUpdate) {
      titleText = "Cập nhật phân loại";
    } else {
      titleText = "Thêm phân loại mới";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            titleText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0, // Optional: Adjust elevation as needed
          backgroundColor: Colors.blue, // Example custom color
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Existing widgets with updated styling
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Example border color
                    ),
                    hintText: 'Nhập tên phân loại',
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _imgController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Chọn ảnh',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => _showImagePicker(context),
                      child: Text(
                          selectedImage.isEmpty ? 'Chọn ảnh' : 'Thay đổi ảnh'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _descController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Example border color
                    ),
                    hintText: 'Nhập mô tả',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    widget.isUpdate
                        ? _onUpdate(widget.categoryModel!.id)
                        : _onSave();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Example custom button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0), // Example padding
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
