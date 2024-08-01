import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api.dart';
import '../../model/category.dart';
import '../../model/product.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final Product? productModel;

  const ProductAdd({super.key, this.isUpdate = false, this.productModel});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? selectedCate;
  List<Category> categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _catIdController = TextEditingController();

  List<String> productImages = [];
  String selectedImage = '';
  String titleText = "";

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
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                final image = productImages[index];
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

  Future<void> _onSave() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addProduct(
        Product(
            id: 0,
            name: name,
            imageUrl: img,
            categoryId: int.parse(catId),
            categoryName: '',
            price: price,
            description: des),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().updateProduct(
        Product(
            id: widget.productModel!.id,
            name: name,
            imageUrl: img,
            categoryId: int.parse(catId),
            categoryName: '',
            price: price,
            description: des),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  Future<void> _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository().getCategory(
      prefs.getString('accountID') ?? '',
      prefs.getString('token') ?? '',
    );

    setState(() {
      if (temp.isNotEmpty) {
        selectedCate = temp.first.id.toString();
        _catIdController.text = selectedCate.toString();
      } else {
        selectedCate = '';
        _catIdController.text = '';
      }
      categories = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    _loadProductImages();

    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _desController.text = widget.productModel!.description;
      _priceController.text = widget.productModel!.price.toString();
      _imgController.text = widget.productModel!.imageUrl;
      selectedImage = widget.productModel!.imageUrl;
      if (widget.productModel!.imageUrl.isNotEmpty &&
          widget.productModel!.imageUrl != 'Null') {
        Container(
          height: 150,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Image.network(
            widget.productModel!.imageUrl,
            loadingBuilder: (context, child, progress) {
              return progress == null
                  ? child
                  : const CircularProgressIndicator();
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                widget.productModel!.imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              );
            },
          ),
        );
      }
      _catIdController.text = widget.productModel!.categoryId.toString();
    }
    if (widget.isUpdate) {
      titleText = "Update Product";
    } else {
      titleText = "Add New Product";
    }
  }

  Future<void> _loadProductImages() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    const productsDir = 'assets/images/products/';
    productImages = manifestMap.keys
        .where((String key) => key.startsWith(productsDir))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Name:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Price:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter price',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imgController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select image',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _showImagePicker(context),
                    child: Text(selectedImage.isEmpty
                        ? 'Select image'
                        : 'Change image'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (selectedImage.isNotEmpty) ...[
                Center(
                  child: Image.network(
                    selectedImage,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : const CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        selectedImage,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _desController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 50, color: Colors.white))),
                value: selectedCate,
                items: categories
                    .map((item) => DropdownMenuItem<String>(
                          value: item.id.toString(),
                          child: Text(item.name,
                              style: const TextStyle(fontSize: 20)),
                        ))
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    selectedCate = item;
                    _catIdController.text = item.toString();
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    widget.isUpdate ? await _onUpdate() : await _onSave();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
