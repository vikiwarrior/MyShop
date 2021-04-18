import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80',
    ),
    Product(
      id: 'p3',
      title: 'Redish Shirt',
      description: 'it is pretty red!',
      price: 99.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Tttrousers',
      description: 'A nice pair of trousers.',
      price: 539.99,
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favitems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://shop-app-d4b38-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      extractedData.forEach((prodid, data) {
        // print(data['is']);
        loadedProducts.add(
          Product(
              id: prodid,
              description: data['description'],
              imageUrl: data['imageUrl'],
              // imageUrl:
              //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
              price: data['price'],
              title: data['title'],
              isFavorite: data['isFavorite']),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // print('sss');
      throw (error);
    }
  }

  Future<void> addProducts(Product product) async {
    const url =
        'https://shop-app-d4b38-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
          imageUrl: product.imageUrl,
          title: product.title,
          description: product.description,
          price: product.price,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);

      notifyListeners();
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> updateProducts(String id, Product product) async {
    var productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'https://shop-app-d4b38-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));

      _items[productIndex] = product;
      notifyListeners();
    } else {
      print('check...');
    }
  }

  void deleteProduct(String id) {
    final url =
        'https://shop-app-d4b38-default-rtdb.firebaseio.com/products/$id.json';
    final removedProdIndex = _items.indexWhere((prod) => prod.id == id);
    var removedproduct = _items[removedProdIndex];
    _items.removeAt(removedProdIndex);
    http.delete(url).then((_) {
      removedproduct = null;
    }).catchError((_) {
      _items.insert(removedProdIndex, removedproduct);
      notifyListeners();
    });
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
