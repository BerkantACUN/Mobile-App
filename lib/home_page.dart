import 'package:flutter/material.dart';
import 'shopping_page.dart'; // ShoppingPage sayfası eklenmeli

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 3,  // 3 ikon sütun
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: <Widget>[
            CategoryIcon(
              imagePath: 'assets/icons/shopping_cart.png',  // Sepet ikonu
              label: 'Alışveriş',
              category: 'Shopping',
            ),
            CategoryIcon(
              imagePath: 'assets/icons/carr.jpg',  // Araba ikonu
              label: 'Otomotiv',
              category: 'Automotive',
            ),
            CategoryIcon(
              imagePath: 'assets/icons/vaccine.png',  // Aşı ikonu
              label: 'Sağlık',
              category: 'Healthcare',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatefulWidget {
  final String imagePath;
  final String label;
  final String category;

  CategoryIcon({
    required this.imagePath,
    required this.label,
    required this.category,
  });

  @override
  _CategoryIconState createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  bool _isHovered = false;

  void _onTap() {
    if (widget.category == 'Shopping') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShoppingPage()),
      );
    }
    // Otomotiv veya Sağlık kategorisi için başka işlemler eklenebilir
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: InkWell(
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _isHovered ? 120 : 100,  // Hover animasyonu
          height: _isHovered ? 120 : 100,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.blue.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? Colors.blue.shade200 : Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                widget.imagePath,
                width: 60,
                height: 60,
              ),
              SizedBox(height: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
