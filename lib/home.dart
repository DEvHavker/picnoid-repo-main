import 'package:flutter/material.dart';
import 'package:myapp/ar.dart';
import 'package:myapp/measure.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "PicNoid",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 239, 233, 235),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 86, 56, 45),
      ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconButton(
              context,
              Icons.chair,
              const Color.fromARGB(255, 86, 56, 45),
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  const ARScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildIconButton(
              context,
              Icons.draw,
              const Color.fromARGB(255, 86, 56, 45),
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MeasureScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(30),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}