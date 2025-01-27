import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'dart:math' show sqrt, pow;
import 'package:vector_math/vector_math_64.dart' hide Colors;

class MeasureScreen extends StatefulWidget {
  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  ArCoreController? arCoreController;
  List<Vector3> _points = [];
  List<ArCoreNode> _nodes = [];
  String _distanceText = "Tap the '+' button to add a node";

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController!.onPlaneTap = _onPlaneTapHandler;
  }

  void _onPlaneTapHandler(List<ArCoreHitTestResult> hits) {
    if (hits.isNotEmpty) {
      final hit = hits.first;

      // Add a node (sphere) at the tapped position
      _addMarkerAtPosition(hit.pose.translation);
    }
  }

  void _addMarkerAtPosition(Vector3 position) {
    final markerNode = ArCoreNode(
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: Colors.green)],
        radius: 0.03,
      ),
      position: position,
    );

    arCoreController!.addArCoreNode(markerNode);
    _nodes.add(markerNode);
    _points.add(position);

    if (_points.length == 2) {
      _drawLineBetweenPoints(_points[0], _points[1]);
      final distance = _calculateDistance(_points[0], _points[1]);
      setState(() {
        _distanceText = "${(distance * 100).toStringAsFixed(2)} cm";
      });

      // Clear points for the next measurement
      _points.clear();
    }
  }

  void _drawLineBetweenPoints(Vector3 start, Vector3 end) {
    const int segments = 50; // Number of small spheres to draw the line
    final dx = (end.x - start.x) / segments;
    final dy = (end.y - start.y) / segments;
    final dz = (end.z - start.z) / segments;

    for (int i = 0; i <= segments; i++) {
      final position = Vector3(
        start.x + (dx * i),
        start.y + (dy * i),
        start.z + (dz * i),
      );

      final sphereNode = ArCoreNode(
        shape: ArCoreSphere(
          materials: [ArCoreMaterial(color: Colors.blue)],
          radius: 0.005,
        ),
        position: position,
      );

      arCoreController!.addArCoreNode(sphereNode);
      _nodes.add(sphereNode);
    }
  }

  double _calculateDistance(Vector3 start, Vector3 end) {
    return sqrt(
      pow(end.x - start.x, 2) +
      pow(end.y - start.y, 2) +
      pow(end.z - start.z, 2),
    );
  }

  void _clearAllNodes() {
    for (final node in _nodes) {
      arCoreController!.removeNode(nodeName: node.name);
    }
    setState(() {
      _nodes.clear();
      _points.clear();
      _distanceText = "Tap the '+' button to add a node";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Stack(
        children: [
          // ARCore view
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          // Distance label
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2 - 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _distanceText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          // Bottom buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Clear button
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _clearAllNodes,
                  tooltip: "Clear All Nodes",
                ),
                // Add Node button
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _distanceText = "Tap on a plane to add nodes";
                    });
                  },
                  tooltip: "Add Node",
                ),
                // Capture button
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    // Capture functionality (e.g., screenshot)
                  },
                  tooltip: "Capture Scene",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

