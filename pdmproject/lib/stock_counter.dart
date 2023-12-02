import 'package:flutter/material.dart';

class StockCounter extends StatefulWidget {
  final int initialStock;
  final Function(int) onPurchase;

  StockCounter({required this.initialStock, required this.onPurchase});

  @override
  _StockCounterState createState() => _StockCounterState();
}

class _StockCounterState extends State<StockCounter> {
  int currentStock = 0;

  @override
  void initState() {
    super.initState();
    currentStock = widget.initialStock;
  }

  void decrementStock() {
    if (currentStock > 0) {
      setState(() {
        currentStock--;
      });
      widget.onPurchase(currentStock); // Notify the parent widget about the purchase and updated stock
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: decrementStock,
        ),
        Text('$currentStock'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // You can add logic here if needed
          },
        ),
      ],
    );
  }
}
