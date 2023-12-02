import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pdmproject/cart_model.dart'; // Import the CartModel
import 'package:pdmproject/grocery_item_tile.dart';
import 'package:provider/provider.dart';

class Market extends StatelessWidget {
  const Market({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    CurrencyFormat RupiahSettings = CurrencyFormat(
      symbol: 'Rp ',
      symbolSide: SymbolSide.left,
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          const Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 10.0),
            child: Text(
              'Welcome to Laptop Pick',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          // SubHeader
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Let's set you up for buying laptop",
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(),
          ),

          Expanded(
            child: Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: cartModel.shopItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return GroceryItemTile(
                      itemName: cartModel.shopItems[index][0],
                      itemPrice: CurrencyFormatter.format(
                          cartModel.shopItems[index][1], RupiahSettings),
                      imagePath: cartModel.shopItems[index][2],
                      color: cartModel.shopItems[index][3],
                      stockLimit: 5, // Set the stock limit for each item
                      onPressed: () => cartModel.addItemToCart(
                        cartModel.shopItems[index][0],
                        5, // Set the stock limit for each item
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
