import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/flutter_workflow.dart';

// Main entry point for the example application
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the theme to the entire widget tree
    return FlowCanvasThemeProvider(
      theme: FlowCanvasTheme.dark(),
      child: const MaterialApp(
        home: CanvasScreen(),
      ),
    );
  }
}

// A stateful widget to manage the lifecycle of the facade and shader
class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  late final FlowCanvasFacade facade;
  late final NodeRegistry nodeRegistry;
  late final EdgeRegistry edgeRegistry;
  ui.FragmentProgram? backgroundShader;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Registries
    nodeRegistry = NodeRegistry();
    edgeRegistry = EdgeRegistry();

    // 2. Register Custom Node Types
    // The user defines their own widgets and registers them with a unique type.
    nodeRegistry.register('custom_node', (node) {
      // The facade is passed down to the custom node widgets so they can
      // use interactive elements like the Handle.
      return CustomNodeWidget(node: node, facade: facade);
    });

    // 3. Initialize the Facade
    // This is the main entry point to the library's functionality.
    facade = FlowCanvasFacade(
      nodeRegistry: nodeRegistry,
      edgeRegistry: edgeRegistry,
    );

    // 4. Load assets like shaders
    _loadShader();

    // 5. Add initial data to the canvas
    _addInitialNodes();
  }

  Future<void> _loadShader() async {
    // In a real app, this would be handled by a proper asset manager
    // final program = await ui.FragmentProgram.fromAsset('assets/shaders/background.frag');
    // setState(() {
    //   backgroundShader = program;
    // });
  }

  void _addInitialNodes() {
    // Use the facade to add nodes to the canvas
    final node1 = FlowNode.create(
      position: const Offset(100, 200),
      size: const Size(150, 80),
      type: 'custom_node',
      handles: const [
        NodeHandle(
            id: 'out1', type: HandleType.source, position: Offset(150, 40)),
      ],
      data: {'label': 'Node A'},
    );

    final node2 = FlowNode.create(
      position: const Offset(400, 300),
      size: const Size(150, 80),
      type: 'custom_node',
      handles: const [
        NodeHandle(id: 'in1', type: HandleType.target, position: Offset(0, 40)),
      ],
      data: {'label': 'Node B'},
    );

    facade.addNode(node1);
    facade.addNode(node2);
  }

  @override
  void dispose() {
    facade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The main canvas widget
          FlowCanvas(
            nodeRegistry: nodeRegistry,
            edgeRegistry: edgeRegistry,
            // backgroundShader: backgroundShader, // Pass the shader when loaded
          ),

          // Peripheral UI widgets that interact with the canvas via the facade
          FlowMiniMap(facade: facade),

          Positioned(
            top: 20,
            left: 20,
            child: FlowCanvasControls(facade: facade),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example of interacting with the canvas from external buttons
          facade.addNode(
            FlowNode.create(
                position: const Offset(250, 100),
                size: const Size(150, 80),
                type: 'custom_node',
                data: {
                  'label': 'New Node'
                },
                handles: const [
                  NodeHandle(
                      id: 'in1',
                      type: HandleType.target,
                      position: Offset(0, 40)),
                  NodeHandle(
                      id: 'out1',
                      type: HandleType.source,
                      position: Offset(150, 40)),
                ]),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// An example of a custom node widget a user of the library would create.
class CustomNodeWidget extends StatelessWidget {
  final FlowNode node;
  final FlowCanvasFacade facade;

  const CustomNodeWidget({
    super.key,
    required this.node,
    required this.facade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.flowCanvasTheme.node;
    // The node's appearance can be driven by its `isSelected` property
    final decoration = theme.getStyleForState(isSelected: node.isSelected);

    return Container(
      width: node.size.width,
      height: node.size.height,
      decoration: decoration.decoration,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              node.data['label'] ?? '',
              style: theme.defaultTextStyle,
            ),
          ),
          // Add handles to the node
          for (final handle in node.handles)
            Positioned(
              left: handle.position.dx - 15, // Center the handle
              top: handle.position.dy - 15, // Center the handle
              child: Handle(
                facade: facade,
                nodeId: node.id,
                handleId: handle.id,
                type: handle.type,
              ),
            ),
        ],
      ),
    );
  }
}
