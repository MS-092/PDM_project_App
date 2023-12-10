import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pdmproject/cart_model.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    CurrencyFormat RupiahSettings = CurrencyFormat(
      symbol: 'Rp',
      symbolSide: SymbolSide.left,
      thousandSeparator: '.',
      decimalSeparator: ',',
      symbolSeparator: ' ',
    );

    return Scaffold(
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          Map<String, int> itemQuantities = {};

          for (var item in value.cartItems) {
            String itemName = item[0];
            itemQuantities[itemName] = itemQuantities.containsKey(itemName)
                ? itemQuantities[itemName]! + 1
                : 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Cart",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text("Cart Items: ${value.cartLength}"),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: itemQuantities.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      String itemName = itemQuantities.keys.elementAt(index);
                      int quantity = itemQuantities[itemName]!;
                      var itemDetails = value.cartItems
                          .firstWhere((item) => item[0] == itemName);

                      // Shorten the itemName display if it has more than 7 characters for the orginal itemName
                      String displayedName =
                          itemName.length > 7 ? itemName.substring(0, 7) + ".." : itemName;

                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      itemDetails[2],
                                      height: 36,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayedName,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          CurrencyFormatter.format(itemDetails[1], RupiahSettings).toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        Provider.of<CartModel>(context, listen: false)
                                            .removeItemFromCart(index);
                                      }
                                      else if (quantity <= 0) {
                                        Provider.of<CartModel>(context, listen: false)
                                          .removeAllItemByName(itemName);
                                      }
                                    },
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                    // Assuming you have access to the itemName, call the method to increment quantity
                                    Provider.of<CartModel>(context, listen: false)
                                    .incrementItemQuantity(itemName);
                                  },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      Provider.of<CartModel>(context, listen: false)
                                          .removeAllItemByName(itemName);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(color: Colors.green[200]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            value.calculateTotal(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (value.cartLength > 0) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.success,
                              title: 'Payment Successful!',
                              desc: 'Thanks for purchasing our products!',
                              btnOkOnPress: () {
                                value.removeAllItemFromCart();
                              },
                            )..show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.error,
                              title: 'Error',
                              desc: 'No items added to the cart.',
                              btnOkOnPress: () {},
                            )..show();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                        ),
                        child: Row(
                          children: const [
                            Text(
                              'Pay Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
