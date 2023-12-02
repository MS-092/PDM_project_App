import 'package:flutter/material.dart';
import 'package:currency_formatter/currency_formatter.dart';

class CartModel extends ChangeNotifier {
  CurrencyFormat RupiahSettings = CurrencyFormat(
    symbol: 'Rp ',
    symbolSide: SymbolSide.left,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Asus Tuf Gaming f15", 17999000, "assets/tuf.png", Colors.yellow],
    ["HP Victus 16", 22999000, "assets/Victus.jpeg", Colors.red],
    ["Macbook Pro M1", 16499000, "assets/macbook.jpeg", Colors.green],
    ["Lenovo Legion Pro 5i", 31879000, "assets/legion.jpeg", Colors.indigo],
  ];

  // list of cart items
  List _cartItems = [];

  // map to track purchased items and their counts
  Map<String, int> _purchasedItems = {};

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  get cartLength => _cartItems.length;

  // add item to cart
  void addItemToCart(String itemName, int stockLimit) {
    int itemCountInCart = _cartItems.where((item) => item[0] == itemName).length;
    
    // Check if the stock limit is reached
    if (itemCountInCart < stockLimit) {
      _cartItems.add(List.from(_shopItems.firstWhere((item) => item[0] == itemName)));
      _purchasedItems.update(itemName, (count) => count + 1, ifAbsent: () => 1);
      notifyListeners();
    }
  }

  // remove item from cart
  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    
    notifyListeners();
  }


  void removeAllItemFromCart() {
    _cartItems.clear();
    _purchasedItems.clear();
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1].toString());
    }
    return CurrencyFormatter.format(totalPrice, RupiahSettings).toString();
  }
}
