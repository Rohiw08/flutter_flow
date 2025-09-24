import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_workflow/flutter_workflow.dart';

// A custom node widget for demonstration purposes.
class CustomNodeWidget extends StatelessWidget {
  final FlowNode node;

  const CustomNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            node.data['label'] ?? 'Custom Node',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('This is a custom widget!'),
        ],
      ),
    );
  }
}

// 1. Define initial nodes for the canvas.
final List<FlowNode> initialNodes = [
  FlowNode.create(
    id: '1',
    position: const Offset(100, 100),
    size: const Size(150, 80),
    type: 'default',
    handles: [
      const NodeHandle(
          id: '1-out', type: HandleType.source, position: Offset(150, 40)),
    ],
    data: {'label': 'Default Node 1'},
  ),
  FlowNode.create(
    id: '2',
    position: const Offset(400, 200),
    size: const Size(150, 80),
    type: 'custom',
    handles: [
      const NodeHandle(
          id: '2-in', type: HandleType.target, position: Offset(0, 40)),
    ],
    data: {'label': 'My Custom Node'},
  ),
];

// 2. Define initial edges (connections) for the canvas.
final List<FlowEdge> initialEdges = [
  const FlowEdge(
    id: 'e1-2',
    sourceNodeId: '1',
    sourceHandleId: '1-out',
    targetNodeId: '2',
    targetHandleId: '2-in',
  ),
];

// 3. Set up the registries for custom node and edge types.
final nodeRegistry = NodeRegistry()
  ..registerDefaultTypes() // Includes 'default', 'input', 'output'
  ..register('custom', (node) => CustomNodeWidget(node: node));

final edgeRegistry = EdgeRegistry(); // Can be used for custom edge types

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Example(),
      ),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final FlowController _controller =
      FlowController(nodeRegistry: nodeRegistry, edgeRegistry: edgeRegistry);

  @override
  void initState() {
    super.initState();
    _controller.controller.addNodes(initialNodes);
    _controller.controller.importEdges(initialEdges);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add some buttons to interact with the controlled canvas
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  final newNode = FlowNode.create(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    position: const Offset(200, 300),
                    size: const Size(150, 80),
                    type: 'default',
                    handles: [
                      const NodeHandle(
                          id: 'new-in',
                          type: HandleType.target,
                          position: Offset(0, 40)),
                    ],
                    data: {'label': 'Added Node'},
                  );
                  _controller.controller.addNode(newNode);
                },
                child: const Text('Add Node'),
              ),
              ElevatedButton(
                onPressed: () => _controller.controller.removeSelectedNodes(),
                child: const Text('Remove Selected'),
              ),
              ElevatedButton(
                onPressed: () => _controller.controller.fitView(),
                child: const Text('Fit View'),
              ),
              ElevatedButton(
                onPressed: () => _controller.controller.undo(),
                child: const Text('Undo'),
              ),
              ElevatedButton(
                onPressed: () => _controller.controller.redo(),
                child: const Text('Redo'),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: FlowCanvas(
            controller: _controller,
            nodeRegistry: nodeRegistry,
            edgeRegistry: edgeRegistry,
          ),
        ),
      ],
    );
  }
}
