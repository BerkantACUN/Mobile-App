import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart'; // WebRTC için

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alışveriş Platformları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 3,  // 3 ikon sütun
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: <Widget>[
            ShoppingPlatformIcon(
              imagePath: 'assets/icons/n11.png',
              label: 'N11',
            ),
            ShoppingPlatformIcon(
              imagePath: 'assets/icons/amazon.jpg',
              label: 'Amazon',
            ),
            ShoppingPlatformIcon(
              imagePath: 'assets/icons/trendyol.png',
              label: 'Trendyol',
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingPlatformIcon extends StatefulWidget {
  final String imagePath;
  final String label;

  ShoppingPlatformIcon({
    required this.imagePath,
    required this.label,
  });

  @override
  _ShoppingPlatformIconState createState() => _ShoppingPlatformIconState();
}

class _ShoppingPlatformIconState extends State<ShoppingPlatformIcon> {
  bool _isHovered = false;
  bool _isLoading = false;

  void _connectToSupport() {
    setState(() {
      _isLoading = true;
    });

    // Simüle edilmiş bir gecikme (canlı desteğe bağlanıyormuş gibi)
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Canlı Desteğe Bağlanılıyor'),
          content: Text('${widget.label} ile bağlanıyorsunuz...'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _connectToSupport,
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
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 3.0,
                  ),
                )
              else
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
