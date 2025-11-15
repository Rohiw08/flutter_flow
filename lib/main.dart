import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flow_canvas/flow_canvas.dart';
import 'package:flutter_flow/input_node.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () => _toggleTheme(),
              icon: _themeMode == ThemeMode.dark
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode),
            ),
          ],
        ),
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
  final controller = FlowCanvasController();

  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _isSelectionMode = false;
  }

  late final nodeRegistry = NodeRegistry()
    ..register(
      'colorPicker',
      (node) {
        return ColorPickerCard(
          node: node,
          controller: controller,
        );
      },
    )
    ..register('InputNode', (node) {
      return InputNode(
        node: node,
        controller: controller,
      );
    });

  final edgeRegistry = EdgeRegistry();

  final List<FlowNode> initialNodes = [
    FlowNode.create(
      id: '1',
      position: const Offset(400, 200),
      size: const Size(150, 100),
      type: 'colorPicker',
      handles: [
        const FlowHandle(
          id: '1-both-1',
          type: HandleType.source,
          position: Offset(-75, -25),
        ),
        const FlowHandle(
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
        const FlowHandle(
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
        const FlowHandle(
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
      selectable: true,
      draggable: false,
      handles: [
        const FlowHandle(
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
    FlowNode.create(
      id: '5',
      position: const Offset(100, 300),
      size: const Size(150, 150),
      type: DefaultNodeType.defaultNode.toString(),
      handles: [
        const FlowHandle(
          id: '5-both-1',
          type: HandleType.target,
          position: Offset(75, 40),
        ),
      ],
      data: {
        'label': 'default Node',
      },
    ),
  ];

  final List<FlowEdge> initialEdges = [
    const FlowEdge(
      id: 'e1-2',
      type: EdgePathType.step,
      sourceNodeId: '1',
      sourceHandleId: '1-both-1',
      targetNodeId: '2',
      targetHandleId: '2-both-1',
      label: Text("Edge Label"),
      endMarkerStyle: FlowEdgeMarkerStyle(
        markerType: EdgeMarkerType.arrow,
        decoration: FlowMarkerDecoration(size: Size(8, 8), color: Colors.black),
      ),
      startMarkerStyle: FlowEdgeMarkerStyle(
        markerType: EdgeMarkerType.arrow,
        decoration: FlowMarkerDecoration(size: Size(8, 8), color: Colors.black),
      ),
    ),
    FlowEdge(
      id: 'e3-1',
      type: EdgePathType.straight,
      sourceNodeId: '3',
      sourceHandleId: '3-both-1',
      targetNodeId: '1',
      targetHandleId: '1-both-2',
      label: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Text(
          "Custom Label",
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
      labelDecoration: FlowEdgeLabelStyle.dark(),
    ),
  ];

  void addNode(FlowCanvasController controller) {
    controller.nodes.addNode(
      FlowNode.create(
        id: IdGenerator.generateNodeId(),
        type: "ColorPicker",
        position: Offset.zero,
        size: const Size(200, 200),
        data: {"label": "node"},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     IconButton(
        //       onPressed: () => addNode(_controller!),
        //       icon: const Icon(Icons.add),
        //     )
        //   ],
        // ),
        Expanded(
          child: FlowCanvas(
            controller: controller,
            nodeRegistry: nodeRegistry,
            edgeRegistry: edgeRegistry,
            initialNodes: initialNodes,
            initialEdges: initialEdges,
            options: const FlowCanvasOptions(
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
                selectable: true,
                elevateNodesOnSelected: true,
              ),
            ),
            theme: FlowCanvasTheme.system(context).copyWith(
              connection: FlowConnectionStyle.light().copyWith(),
            ),
            overlays: const [
              FlowBackground(),
              FlowMiniMap(),
              FlowCanvasControls(
                showLock: false,
                // TODO: check how can we update state from outside of library
                // children: [
                //   ControlButton(
                //     icon: _isSelectionMode ? Icons.mouse : Icons.select_all,
                //     tooltip: "Select",
                //     onPressed: () {
                //       controller.updateStateOnly(_controller!.currentState
                //           .copyWith(
                //               dragMode: _isSelectionMode
                //                   ? DragMode.none
                //                   : DragMode.selection));
                //       setState(() {
                //         _isSelectionMode = !_isSelectionMode;
                //       });
                //     },
                //   )
                // ],
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
    return DefaultNodeWidget(
      node: widget.node,
      child: GestureDetector(
        onTap: _showColorPickerDialog,
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
    );
  }
}
