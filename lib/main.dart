import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:myapp/home.dart';
//import 'package:myapp/ar.dart';
//import 'package:myapp/measure.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ARCoreChecker(),
    );
  }
}

class ARCoreChecker extends StatefulWidget {
  const ARCoreChecker({super.key});

  @override
  State<ARCoreChecker> createState() => _ARCoreCheckerState();
}

class _ARCoreCheckerState extends State<ARCoreChecker> {
  bool _isARCoreAvailable = false;
  bool _checkComplete = false;

  @override
  void initState() {
    super.initState();
    _checkARCoreAvailability();
  }

  Future<void> _checkARCoreAvailability() async {
    try {
      bool isAvailable = await ArCoreController.checkArCoreAvailability();
      setState(() {
        _isARCoreAvailable = isAvailable;
        _checkComplete = true;
      });
    } catch (e) {
      setState(() {
        _checkComplete = true;
      });
      print("Error checking ARCore availability: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkComplete) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isARCoreAvailable) {
      return  const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("AR Not Supported")),
        body: const Center(
          child: Text(
            "ARCore is not supported on this device. Please update Google Play Services or use a supported device.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }
}
