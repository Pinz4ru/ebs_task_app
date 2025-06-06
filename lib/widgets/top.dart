import 'package:flutter/material.dart';

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 130,
          color: Colors.white,
          child: Stack(
            children: [
              // Search Field
              Positioned(
                left: 16,
                top: 74,
                child: Container(
                  width: 290,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search products',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Shopping Cart Button
              Positioned(
                left: 319,
                top: 74,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C569),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
