import 'package:flutter/material.dart';
import 'package:pdmproject/cart_page.dart';
import 'package:pdmproject/intro.dart';
import 'package:pdmproject/market.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.username}); //Constructor

  final String username;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var getusername = widget.username;
    final List<Widget> _widgetOptions = <Widget>[
      Market(username: getusername), //rebuild everytime when we call the function ++ memory
      CartPage(), //We dont need to rebuild the cart page since we have provider.
    ];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Laptop Marketplace',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[700],
            ),
          ),
          centerTitle: false,
          actions: [
            MaterialButton(
                onPressed: () async {
                  // confirmation dialog
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Confirmation',
                    desc: 'Do you want to logout?',
                    btnCancelOnPress: () {},
                    btnCancelText: "No, take me back",
                    btnOkOnPress: () {
                      // After successful logout, the user will be going to the login page
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => IntroScreen()),
                      );
                    },
                    btnOkText: "Yes",
                  )..show();
                },
                child: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 35,
                ))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.indigo,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped),
        body: _widgetOptions[_selectedIndex]);
  }
}
