import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ArCoreController arCoreController;
  List<ArCoreNode> nodes = [];
  List<ArCoreHitTestResult> hits = [];

  // List of available models
  final List<String> models = [
    'models/bed.glb',
    'models/chair.glb',
    'models/table.glb',
  ];

  String? selectedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Screen'),
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
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ElevatedButton(
          onPressed: _showModelPicker,
          child: const Text('Choose Model'),
        ),
        const SizedBox(width: 10), // Add spacing between buttons
        ElevatedButton(
          onPressed: _addModelFromLastHit,
          child: const Text('Add Model'),
        ),
        const SizedBox(width: 10), // Add spacing between buttons
        ElevatedButton(
          onPressed: _removeLastModel,
          child: const Text('Remove Last Model'),
        ),
      ],
    ),
  ),
)
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    if (hits.isNotEmpty) {
      this.hits = hits; // Store the hits for later use
    }
  }
  

  void _addModelFromLastHit() {
    if (hits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tap on a plane first!')),
      );
      return;
    }

    if (selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a model first!')),
      );
      return;
    }

    final hit = hits.first;
    _addModel(hit, selectedModel!);
  }

  void _addModel(ArCoreHitTestResult hit, String modelPath) async {
    try {
      final ByteData data = await rootBundle.load(modelPath);
      final Directory tempDir = await Directory.systemTemp.createTemp();
      final File tempFile = File('${tempDir.path}/${modelPath.split('/').last}');
      await tempFile.writeAsBytes(data.buffer.asUint8List());

      final node = ArCoreReferenceNode(
        name: modelPath.split('/').last,
        objectUrl: tempFile.path, // Use the local path
        position: hit.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
        rotation: hit.pose.rotation,
      );

      arCoreController.addArCoreNode(node);
      setState(() {
        nodes.add(node);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model: $e')),
      );
    }
  }

  void _removeLastModel() {
    if (nodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No models to remove!')),
      );
      return;
    }

    final lastNode = nodes.removeLast(); // Remove the last node from the list
    arCoreController.removeNode(nodeName: lastNode.name); // Remove the node from the AR scene

    setState(() {});
  }

  void _showModelPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: models.length,
          itemBuilder: (BuildContext context, int index) {
            final model = models[index];
            return ListTile(
              title: Text(model.split('/').last),
              onTap: () {
                setState(() {
                  selectedModel = model;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text("Tapped on: $name"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
