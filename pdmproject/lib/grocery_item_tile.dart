import 'package:flutter/material.dart';

class GroceryItemTile extends StatefulWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final Color color;
  final int stockLimit;
  final void Function()? onPressed;

  GroceryItemTile({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.stockLimit,
    this.onPressed,
  }) : super(key: key);

  @override
  _GroceryItemTileState createState() => _GroceryItemTileState();
}

class _GroceryItemTileState extends State<GroceryItemTile> {
  int purchasedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
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

            ElevatedButton(
              onPressed: () {
                if (purchasedCount < widget.stockLimit) {
                  // Update the state and notify the parent about the purchase
                  setState(() {
                    purchasedCount += 1;
                  });
                  // Call the onPressed function passed from the parent
                  widget.onPressed?.call();
                } else {
                  // If the limit is reached, show a message (you can customize this part)
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Purchase Limit Reached'),
                        content: Text('You have reached the purchase limit for ${widget.itemName}.'),
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
              child: Text("Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
