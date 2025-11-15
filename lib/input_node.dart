import 'package:flow_canvas/flow_canvas.dart';
import 'package:flutter/material.dart';

class InputNode extends StatelessWidget {
  final FlowNode _flowNode;
  InputNode(
      {super.key,
      required FlowCanvasController controller,
      required FlowNode node})
      : _flowNode = node;

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultNodeWidget(
      node: _flowNode,
      style: FlowNodeStyle.system(context).copyWith(
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
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Input"),
            const SizedBox(height: 8),
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
                isDense: true, // makes it more compact
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                debugPrint(textEditingController.text);
              },
              child: const Text("Enter"),
            ),
          ],
        ),
      ),
    );
  }
}
