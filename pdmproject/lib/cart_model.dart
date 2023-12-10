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

  final List _shopItems = const [
    ["Asus Tuf Gaming f15", 17999000, "assets/tuf.png", Colors.yellow],
    ["HP Victus 16", 22999000, "assets/Victus.jpeg", Colors.red],
    ["Macbook Pro M1", 16499000, "assets/macbook.jpeg", Colors.green],
    ["Lenovo Legion Pro 5i", 31879000, "assets/legion.jpeg", Colors.indigo],
  ];

  List _cartItems = [];

  Map<String, int> _purchasedItems = {};

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  get cartLength => _cartItems.length;

  void addItemToCart(String itemName, int quantity) {
    int itemCountInCart = _purchasedItems[itemName] ?? 0;

    // Check if the stock limit is reached
    if (itemCountInCart + quantity <= 5) {
      for (int i = 0; i < quantity; i++) {
        _cartItems.add(List.from(_shopItems.firstWhere((item) => item[0] == itemName)));
      }

      _purchasedItems.update(itemName, (count) => count + quantity, ifAbsent: () => quantity);
      notifyListeners();
    }
  }

  void incrementItemQuantity(String itemName) {
    int itemCount = _purchasedItems[itemName] ?? 0;
    
    // Check if incrementing is allowed (within the stock limit)
    if (itemCount < 5) {
      _cartItems.add(List.from(_shopItems.firstWhere((item) => item[0] == itemName)));
      _purchasedItems.update(itemName, (count) => count + 1, ifAbsent: () => 1);
      notifyListeners();
    }
  }

  void removeItemFromCart(int index) {
    String itemName = _cartItems[index][0];
    _cartItems.removeAt(index);

    int itemCountInCart = _purchasedItems[itemName] ?? 0;
    if (itemCountInCart > 0) {
      _purchasedItems.update(itemName, (count) => count - 1, ifAbsent: () => 0);
    }

    notifyListeners();
  }

  void removeAllItemFromCart() {
    _cartItems.clear();
    _purchasedItems.clear();
    notifyListeners();
  }

  void removeAllItemByName(String itemName) {
    int itemCountInCart = _purchasedItems[itemName] ?? 0;
    _cartItems.removeWhere((item) => item[0] == itemName);
    _purchasedItems.remove(itemName);

    if (itemCountInCart > 1) {
      _purchasedItems[itemName] = itemCountInCart - 1;
    }

    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0;

    for (int i = 0; i < _cartItems.length; i++) {
      totalPrice += double.parse(_cartItems[i][1].toString());
    }

    return CurrencyFormatter.format(totalPrice, RupiahSettings).toString();
  }
}
