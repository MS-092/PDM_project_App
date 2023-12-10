import 'package:flutter/material.dart';

class GroceryItemTile extends StatefulWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final Color color;
  final int stockLimit;
  final void Function(int)? onAddToCart;

  GroceryItemTile({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.stockLimit,
    this.onAddToCart,
  }) : super(key: key);

  @override
  _GroceryItemTileState createState() => _GroceryItemTileState();
}

class _GroceryItemTileState extends State<GroceryItemTile> {
  late TextEditingController quantityController;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '1');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.color,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            // item image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset(
                widget.imagePath,
              ),
            ),

            // item name
            Text(
              widget.itemName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            Text(
              widget.itemPrice,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Quantity:'),
                SizedBox(width: 10),
                Container(
                  width: 50,
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int quantity = int.tryParse(value) ?? 0;
                      setState(() {
                        selectedQuantity = quantity;
                      });
                    },
                  ),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                if (selectedQuantity > 0 && selectedQuantity <= widget.stockLimit) {
                  widget.onAddToCart?.call(selectedQuantity);
                  // Reset the quantity controller after adding to cart
                  quantityController.text = '1';
                } else if (selectedQuantity > widget.stockLimit) {
                  // Show error message if quantity exceeds stock limit
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Quantity'),
                        content: Text('The selected quantity exceeds the stock limit (${widget.stockLimit}).'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show error message if quantity is not valid
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Quantity'),
                        content: Text('Please enter a valid quantity between 1 and ${widget.stockLimit}.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: widget.color),
              child: Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
