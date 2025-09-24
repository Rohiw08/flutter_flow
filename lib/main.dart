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
    return MaterialApp(
      theme: ThemeData.light(),
      home: const CanvasScreen(),
    );
  }
}

class CanvasScreen extends ConsumerStatefulWidget {
  const CanvasScreen({super.key});

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  late final NodeRegistry nodeRegistry;
  late final EdgeRegistry edgeRegistry;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCanvas();
  }

  void _initializeCanvas() {
    // 1. Initialize Registries
    nodeRegistry = NodeRegistry();
    edgeRegistry = EdgeRegistry();

    // 2. Get the controller from the provider
    final controller = flowControllerProvider((
      nodeRegistry: nodeRegistry,
      edgeRegistry: edgeRegistry,
    ));

    // 4. Register Custom Node Types
    nodeRegistry.register('custom_node', (node) {
      return CustomNodeWidget(node: node);
    });

    // 5. Mark as initialized
    setState(() {
      _isInitialized = true;
    });

    // 6. Add initial data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _addInitialNodes();
      }
    });
  }

  void addNode() {
    final node = FlowNodeFactory.create(
      id: 'node_${DateTime.now().millisecondsSinceEpoch}',
      position: const Offset(0, 300),
      size: const Size(150, 80),
      type: 'custom_node',
      handles: const [
        NodeHandle(
            id: 'out1', type: HandleType.source, position: Offset(150, 40)),
      ],
      data: {'label': 'New Node'},
    );
    controller.addNode(node);
  }

  void _addInitialNodes() {
    try {
      final node1 = FlowNodeFactory.create(
        id: 'node_1',
        position: const Offset(400, 300),
        size: const Size(150, 80),
        type: 'custom_node',
        handles: const [
          NodeHandle(
              id: 'out1', type: HandleType.source, position: Offset(150, 40)),
        ],
        data: {'label': 'Node A'},
      );

      final node2 = FlowNodeFactory.create(
        id: 'node_2',
        position: const Offset(200, 200),
        size: const Size(150, 80),
        type: 'custom_node',
        handles: const [
          NodeHandle(
              id: 'in1', type: HandleType.target, position: Offset(0, 40)),
        ],
        data: {'label': 'Node B'},
      );

      facade.addNode(node1);
      facade.addNode(node2);
    } catch (e) {
      debugPrint('Error adding initial nodes: $e');
    }
  }

  @override
  void dispose() {
    facade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Canvas...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: addNode,
            child: const Icon(Icons.add),
          )
        ],
      ),
      body: FlowCanvas(
        nodeRegistry: nodeRegistry,
        edgeRegistry: edgeRegistry,
        facade: facade,
        overlays: [
          FlowBackground(
            backgroundTheme: FlowBackgroundStyle.light(),
          ),
          // FlowMiniMap(facade: facade),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FlowCanvasControls(
                facade: facade,
                controlsTheme: const FlowCanvasControlsStyle(
                  containerCornerRadius: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom node widget example
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
    final isSelected = facade.state.selectedNodes.contains(node.id);
    final decoration = theme.getStyleForState(isSelected: isSelected);

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
          for (final handle in node.handles.values)
            Positioned(
              left: handle.position.dx - 15,
              top: handle.position.dy - 15,
              child: Handle(
                nodeId: node.id,
                handleId: handle.id,
                type: handle.type,
                connectionStream: Stream.value(null), // Placeholder
                onStartConnection: (nodeId, handleId, position) {
                  facade.startConnection(nodeId, handleId, position);
                },
                onEndConnection: () {
                  facade.endConnection();
                },
              ),
            ),
        ],
      ),
    );
  }
}
