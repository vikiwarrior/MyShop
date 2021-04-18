import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/widgets/app_drawer.dart';

import '../provider/products.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('your products'),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsdata.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                    productsdata.items[i].id,
                    productsdata.items[i].title,
                    productsdata.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            )),
      ),
    );
  }
}
