import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../provider/products.dart';

enum FilterOptions {
  Favourite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavourites = false;
  bool _init = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = false;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Myshop'), actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.Favourite) {
                _showOnlyFavourites = true;
              } else {
                _showOnlyFavourites = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Only fav'),
              value: FilterOptions.Favourite,
            ),
            PopupMenuItem(
              child: Text('Show all'),
              value: FilterOptions.All,
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemsCount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavourites),
    );
  }
}
