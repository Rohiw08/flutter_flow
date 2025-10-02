import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/flow_canvas.dart';

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
  FlowCanvasController? _controller;

  // 1. Define initial nodes for the canvas.
  late final List<FlowNode> initialNodes = [
    FlowNode.create(
      id: '1',
      position: const Offset(400, 200),
      size: const Size(150, 100),
      type: 'colorPicker',
      handles: [
        const NodeHandle(
          id: '1-both-1',
          type: HandleType.source,
          position: Offset(-75, -25),
        ),
        const NodeHandle(
          id: '1-both-2',
          type: HandleType.both,
          position: Offset(75, -25),
        ),
      ],
      data: {
        'label': 'My Custom Node',
      },
    ),
    // This node will use the self-contained ColorPickerCard.
    FlowNode.create(
      id: '2',
      position: const Offset(50, 250),
      size: const Size(200, 110), // Match the card's size
      type: 'colorPicker',
      handles: [
        const NodeHandle(
          id: '2-both-1',
          type: HandleType.both,
          position: Offset(100, 30),
        ),
      ],
      data: {
        'label': 'Color Node',
        'color': const Color(0xFF443a49), // Initial color for this node
      },
    ),

    FlowNode.create(
      id: '3',
      position: const Offset(100, 100),
      size: const Size(150, 150), // Match the card's size
      type: 'colorPicker',
      handles: [
        const NodeHandle(
          id: '3-both-1',
          type: HandleType.both,
          position: Offset(75, 40),
        ),
      ],
      data: {
        'label': 'Color Node',
        'color': const Color(0xFF443a49), // Initial color for this node
      },
    ),
  ];

  // 2. Define initial edges (connections) for the canvas.
  final List<FlowEdge> initialEdges = [
    const FlowEdge(
      id: 'e1-2',
      pathType: EdgePathType.step,
      sourceNodeId: '1',
      sourceHandleId: '1-both-1',
      targetNodeId: '2',
      targetHandleId: '2-both-1',
    ),
    const FlowEdge(
      id: 'e3-1',
      pathType: EdgePathType.straight,
      sourceNodeId: '3',
      sourceHandleId: '3-both-1',
      targetNodeId: '1',
      targetHandleId: '1-both-2',
    ),
  ];

  // 3. Set up the registries for custom node types.
  late final nodeRegistry = NodeRegistry()
    ..register(
      'colorPicker',
      // The builder now passes the node and controller to the stateful card.
      (node) {
        // We add a check to ensure the controller is initialized.
        if (_controller == null) return const SizedBox.shrink();
        return ColorPickerCard(
          node: node,
          controller: _controller!,
        );
      },
    );

  final edgeRegistry = EdgeRegistry();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_controller == null) return;
                  final newNode = FlowNode.create(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    position: const Offset(200, 300),
                    size: const Size(150, 80),
                    type: 'default',
                    data: {'label': 'Added Node'},
                  );
                  _controller!.addNode(newNode);
                },
                child: const Text('Add Node'),
              ),
              ElevatedButton(
                onPressed: () => _controller?.removeSelectedNodes(),
                child: const Text('Remove Selected'),
              ),
              ElevatedButton(
                onPressed: () => _controller?.fitView(),
                child: const Text('Fit View'),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: FlowCanvas(
            nodeRegistry: nodeRegistry,
            edgeRegistry: edgeRegistry,
            initialNodes: initialNodes,
            initialEdges: initialEdges,
            // We use setState here to trigger a rebuild once the controller is ready.
            onCanvasCreated: (controller) =>
                setState(() => _controller = controller),
            options: const FlowOptions(
              viewportOptions: ViewportOptions(
                maxZoom: 3.0,
                minZoom: 0.3,
              ),
              nodeOptions: NodeOptions(
                elevateNodesOnSelected: false,
              ),
            ),
            overlays: const [
              FlowBackground(),
              FlowMiniMap(),
              FlowCanvasControls(),
            ],
          ),
        ),
      ],
    );
  }
}

/// A stateful widget that displays a color and handles opening a
/// color picker dialog to update its own state and the associated flow node.
class ColorPickerCard extends StatefulWidget {
  final FlowNode node;
  final FlowCanvasController controller;

  const ColorPickerCard({
    super.key,
    required this.node,
    required this.controller,
  });

  @override
  State<ColorPickerCard> createState() => _ColorPickerCardState();
}

class _ColorPickerCardState extends State<ColorPickerCard> {
  // The card now manages its own color state.
  late Color currentColor;
  // This is a temporary color used only by the dialog.
  late Color pickerColor;

  @override
  void initState() {
    super.initState();
    // Initialize the color from the node data passed in.
    currentColor = widget.node.data['color'] ?? Colors.pink;
    pickerColor = currentColor;
  }

  // This lifecycle method ensures that if the node's color is changed
  // by an external source, the card's UI will update to match.
  @override
  void didUpdateWidget(covariant ColorPickerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newColor = widget.node.data['color'];
    if (newColor != null && newColor != currentColor) {
      setState(() {
        currentColor = newColor;
      });
    }
  }

  // Callback for live color changes within the picker dialog.
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // This method now lives inside the widget that uses it.
  void _showColorPickerDialog() {
    // Reset pickerColor to the current confirmed color when opening.
    pickerColor = currentColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            paletteType: PaletteType.hsv,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              // 1. Update the card's own state to reflect the change immediately.
              setState(() {
                currentColor = pickerColor;
              });

              // 2. Update the source of truth: the node's data in the controller.
              final newNodeData = Map<String, dynamic>.from(widget.node.data);
              newNodeData['color'] = currentColor;
              final updatedNode = widget.node.copyWith(data: newNodeData);
              widget.controller.updateNode(updatedNode);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String colorString = currentColor.value.toRadixString(16).padLeft(8, '0');
    String hexCode = colorString.substring(2);
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _showColorPickerDialog,
          child: Container(
            height: widget.node.size.height,
            width: widget.node.size.width,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(230),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(230, 92, 92, 92),
                width: 0.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Text(
                    'shape color',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF131313),
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color.fromARGB(25, 0, 0, 0),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsGeometry.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: currentColor, // Uses internal state
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 220, 220, 220),
                                  width: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '#$hexCode',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF131313),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ...widget.node.handles.values.map(
          (handle) => Handle(
            handleStyle: FlowHandleStyle(size: handle.size),
            nodeId: widget.node.id,
            handleId: handle.id, // Renamed for clarity
            type: handle.type, // An output handle
            position: handle.position,
          ),
        ),
      ],
    );
  }
}
