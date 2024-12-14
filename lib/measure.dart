import 'dart:math';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AdvancedMeasureScreen extends StatefulWidget {
  const AdvancedMeasureScreen({super.key});

  @override
  State<AdvancedMeasureScreen> createState() => _AdvancedMeasureScreenState();
}

class _AdvancedMeasureScreenState extends State<AdvancedMeasureScreen> {
  late ArCoreController arCoreController;
  final List<ArCoreNode> nodes = [];
  final List<vector.Vector3> positions = []; // Store positions for distance calculations.
  final List<String> distances = []; // Store calculated distances for display.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Measuring App'),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _placeNode,
                  child: const Text('Place Node'),
                ),
                ElevatedButton(
                  onPressed: _calculateAndDisplayDistances,
                  child: const Text('Show Distances'),
                ),
                ElevatedButton(
                  onPressed: _removeLastNode,
                  child: const Text('Remove Last Node'),
                ),
              ],
            ),
          ),
          // Display distances as overlay text
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: distances
                  .map((distance) => Text(
                        distance,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (hits.isNotEmpty) {
      final hit = hits.first;
      _addSphereNode(hit.pose.translation);
    }
  }

  void _addSphereNode(vector.Vector3 position) {
    final nodeName = 'node_${nodes.length + 1}';

    final node = ArCoreNode(
      name: nodeName,
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: Colors.red)],
        radius: 0.02,
      ),
      position: position,
    );

    arCoreController.addArCoreNode(node);
    setState(() {
      nodes.add(node);
      positions.add(position);
    });
  }

  void _placeNode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tap on a plane to place a node!')),
    );
  }

  void _calculateAndDisplayDistances() {
    if (positions.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place at least two nodes!')),
      );
      return;
    }

    distances.clear(); // Clear existing distances
    for (int i = 0; i < positions.length - 1; i++) {
      final distance = _calculateDistance(positions[i], positions[i + 1]);
      distances.add('Distance between Node ${i + 1} and ${i + 2}: ${(distance * 100).toStringAsFixed(2)} cm');
      _drawLineBetweenNodes(positions[i], positions[i + 1]);
    }

    setState(() {}); // Refresh the widget to show updated distances
  }

  double _calculateDistance(vector.Vector3 pos1, vector.Vector3 pos2) {
    return sqrt(
      pow(pos1.x - pos2.x, 2) +
      pow(pos1.y - pos2.y, 2) +
      pow(pos1.z - pos2.z, 2),
    );
  }

  void _drawLineBetweenNodes(vector.Vector3 start, vector.Vector3 end) {
  final midPoint = vector.Vector3(
    (start.x + end.x) / 2,
    (start.y + end.y) / 2,
    (start.z + end.z) / 2,
  );

  final distanceVector = end - start;
  final height = distanceVector.length;

  // Create a rotation quaternion for the cylinder
  final vector.Quaternion quaternion = vector.Quaternion.axisAngle(
    vector.Vector3(0.0, 1.0, 0.0), // Axis for rotation
    vector.radians(90), // Angle of rotation
  );

  // Convert Quaternion to Vector4
  final vector.Vector4 rotationVector = vector.Vector4(
    quaternion.x,
    quaternion.y,
    quaternion.z,
    quaternion.w,
  );

  final cylinder = ArCoreCylinder(
    radius: 0.005,
    height: height,
    materials: [ArCoreMaterial(color: Colors.green)],
  );

  final lineNode = ArCoreNode(
    shape: cylinder,
    position: midPoint,
    rotation: rotationVector, // Pass as Vector4
  );

  arCoreController.addArCoreNode(lineNode);
}


  void _removeLastNode() {
    if (nodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No nodes to remove!')),
      );
      return;
    }

    final lastNode = nodes.removeLast();
    positions.removeLast();
    distances.clear(); // Reset distances after node removal

    arCoreController.removeNode(nodeName: lastNode.name!);

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Last node removed!')),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
