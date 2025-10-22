import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_canvas/flow_canvas.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Example(onToggleTheme: _toggleTheme),
      ),
    );
  }
}

class Example extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const Example({super.key, required this.onToggleTheme});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  FlowCanvasController? _controller;
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _isSelectionMode = false;
  }

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
    FlowNode.create(
      id: '2',
      position: const Offset(50, 250),
      size: const Size(200, 110),
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
        'color': const Color(0xFF443a49),
      },
    ),
    FlowNode.create(
      id: '3',
      position: const Offset(100, 100),
      size: const Size(150, 150),
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
        'color': const Color(0xFF443a49),
      },
    ),
    FlowNode.create(
      id: '4',
      position: const Offset(100, 300),
      size: const Size(150, 150),
      type: 'InputNode',
      handles: [
        const NodeHandle(
          id: '4-both-1',
          type: HandleType.target,
          position: Offset(75, 40),
        ),
      ],
      data: {
        'label': 'Color Node',
        'color': const Color.fromARGB(255, 166, 87, 206),
      },
    ),
  ];

  final List<FlowEdge> initialEdges = [
    const FlowEdge(
      id: 'e1-2',
      pathType: EdgePathType.step,
      sourceNodeId: '1',
      sourceHandleId: '1-both-1',
      targetNodeId: '2',
      targetHandleId: '2-both-1',
      endMarkerStyle: FlowEdgeMarkerStyle(
        type: EdgeMarkerType.arrow,
        decoration: FlowMarkerDecoration(size: Size(8, 8), color: Colors.black),
      ),
      startMarkerStyle: FlowEdgeMarkerStyle(
        type: EdgeMarkerType.arrow,
        decoration: FlowMarkerDecoration(size: Size(8, 8), color: Colors.black),
      ),
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

  late final nodeRegistry = NodeRegistry()
    ..register(
      'colorPicker',
      (node) {
        if (_controller == null) return const SizedBox.shrink();
        return ColorPickerCard(
          node: node,
          controller: _controller!,
        );
      },
    )
    ..register('InputNode', (node) {
      if (_controller == null) return const SizedBox.shrink();
      return InputNode(
        node: node,
        controller: _controller!,
      );
    });

  final edgeRegistry = EdgeRegistry();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FlowCanvas(
            nodeRegistry: nodeRegistry,
            edgeRegistry: edgeRegistry,
            initialNodes: initialNodes,
            initialEdges: initialEdges,
            onCanvasCreated: (controller) {
              setState(() => _controller = controller);
            },
            options: const FlowOptions(
              viewportOptions: ViewportOptions(
                maxZoom: 3.0,
                minZoom: 0.3,
                fitViewOptions: FitViewOptions(
                  maxZoom: 3.0,
                  minZoom: 0.3,
                  padding: EdgeInsets.all(1000),
                ),
              ),
              nodeOptions: NodeOptions(
                elevateNodesOnSelected: true,
              ),
              edgeOptions: EdgeOptions(
                animated: true,
              ),
            ),
            theme: FlowCanvasTheme.system(context).copyWith(
              connection: FlowConnectionStyle.light().copyWith(
                endMarkerStyle: const FlowEdgeMarkerStyle(
                  type: EdgeMarkerType.arrow,
                  decoration: FlowMarkerDecoration(
                      size: Size(8, 8), color: Colors.black),
                ),
                startMarkerStyle: const FlowEdgeMarkerStyle(
                  type: EdgeMarkerType.circle,
                  decoration: FlowMarkerDecoration(
                      size: Size(8, 8), color: Colors.black),
                ),
              ),
            ),
            connectionCallbacks: ConnectionCallbacks(
              onConnectEnd: (connection) {
                // Handle connection end
              },
            ),
            overlays: [
              const FlowBackground(),
              const FlowMiniMap(),
              FlowCanvasControls(
                children: [
                  ControlButton(
                    icon: _isSelectionMode ? Icons.mouse : Icons.select_all,
                    tooltip: "Select",
                    onPressed: () {
                      if (_controller == null) return;
                      _controller!.updateStateOnly(_controller!.currentState
                          .copyWith(
                              dragMode: _isSelectionMode
                                  ? DragMode.none
                                  : DragMode.selection));
                      setState(() {
                        _isSelectionMode = !_isSelectionMode;
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
  late Color currentColor;
  late Color pickerColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.node.data['color'] ?? Colors.pink;
    pickerColor = currentColor;
  }

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

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _showColorPickerDialog() {
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
              setState(() {
                currentColor = pickerColor;
              });

              final newNodeData = Map<String, dynamic>.from(widget.node.data);
              newNodeData['color'] = currentColor;
              final updatedNode = widget.node.copyWith(data: newNodeData);
              widget.controller.nodes.updateNode(updatedNode);

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
                  padding: EdgeInsets.all(10),
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
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: currentColor,
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
            handleStyle: const FlowHandleStyle(
              idleDecoration: BoxDecoration(color: Colors.blue),
            ),
            nodeId: widget.node.id,
            handleId: handle.id,
            type: handle.type,
            position: handle.position,
            size: handle.size,
          ),
        ),
      ],
    );
  }
}

class InputNode extends StatelessWidget {
  final FlowCanvasController _controller;
  final FlowNode _flowNode;
  const InputNode(
      {super.key,
      required FlowCanvasController controller,
      required FlowNode node})
      : _controller = controller,
        _flowNode = node;

  void addNode(Offset position) {
    final node = FlowNode.create(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: position,
      size: const Size(150, 80),
      type: 'default',
      data: {'label': 'Added Node'},
    );
    _controller.nodes.addNode(node);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return DefaultNodeWidget(
      node: _flowNode,
      style: FlowNodeStyle.system(context).copyWith(
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
        selectedDecoration: BoxDecoration(
          color: Colors.blue.withAlpha(230),
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
        hoverDecoration: BoxDecoration(
          color: Colors.green.withAlpha(230),
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
        disabledDecoration: BoxDecoration(
          color: Colors.grey.withAlpha(230),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Input"),
          const Spacer(
            flex: 1,
          ),
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          ElevatedButton(
            onPressed: () {
              print(textEditingController.text);
            },
            child: const Text("Enter"),
          ),
        ],
      ),
    );
  }
}
