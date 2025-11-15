import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_canvas/src/features/canvas/application/services/node_service.dart';
import 'package:flow_canvas/src/features/canvas/domain/models/node.dart';
import 'package:flow_canvas/src/features/canvas/domain/flow_canvas_state.dart';
import 'package:flow_canvas/src/features/canvas/domain/indexes/node_index.dart';
import 'package:flow_canvas/src/shared/enums.dart';

// A simple data class for node data in tests
class TestNodeData {
  final String label;
  TestNodeData(this.label);
}

void main() {
  late NodeService nodeService;
  late FlowCanvasState initialState;
  late FlowNode<TestNodeData> node1;
  late FlowNode<TestNodeData> node2;

  // Set up a fresh service and state for each test
  setUp(() {
    nodeService = NodeService();

    node1 = FlowNode.create(
      id: 'node1',
      type: 'default',
      position: const Offset(100, 100),
      size: const Size(100, 50),
      data: TestNodeData('Node 1'),
    );
    node2 = FlowNode.create(
      id: 'node2',
      type: 'default',
      position: const Offset(300, 200),
      size: const Size(100, 50),
      data: TestNodeData('Node 2'),
    );

    initialState = FlowCanvasState.initial().copyWith(
      nodes: {'node1': node1, 'node2': node2},
      nodeIndex: NodeIndex.fromNodes([node1, node2]),
      maxZIndex: 2, // Assume some nodes were added before
    );
  });

  group('NodeService', () {
    group('getNode', () {
      test('returns the correct node when it exists', () {
        final result = nodeService.getNode(initialState, 'node1');
        expect(result, equals(node1));
      });

      test('returns null when the node does not exist', () {
        final result = nodeService.getNode(initialState, 'node-nonexistent');
        expect(result, isNull);
      });
    });

    group('addNode', () {
      test('adds a single node correctly', () {
        final newNode = FlowNode.create(
          id: 'node3',
          type: 'default',
          position: const Offset(500, 500),
          data: TestNodeData('Node 3'),
        );
        final newState = nodeService.addNode(initialState, newNode);

        expect(newState.nodes.length, 3);
        expect(newState.nodes['node3'], isNotNull);
        expect(newState.nodes['node3']!.id, 'node3');
      });

      test('increments and assigns zIndex correctly', () {
        final newNode = FlowNode.create(
          id: 'node3',
          type: 'default',
          position: const Offset(500, 500),
          data: TestNodeData('Node 3'),
        );
        final newState = nodeService.addNode(initialState, newNode);

        expect(newState.maxZIndex, 3);
        expect(newState.nodes['node3']!.zIndex, 3);
      });

      test('updates the node index', () {
        final newNode = FlowNode.create(
          id: 'node3',
          type: 'default',
          position: const Offset(500, 500),
          data: TestNodeData('Node 3'),
        );
        final newState = nodeService.addNode(initialState, newNode);

        expect(newState.nodeIndex.getNode('node3'), isNotNull);
        expect(newState.nodeIndex.getNode('node3')!.id, 'node3');
      });

      test('does not add a node if ID already exists', () {
        final duplicateNode = node1.copyWith(position: const Offset(999, 999));
        final newState = nodeService.addNode(initialState, duplicateNode);

        expect(newState.nodes.length, 2);
        expect(newState.nodes['node1']!.position,
            const Offset(100, 100)); // Unchanged
        expect(newState, equals(initialState)); // Should return same state
      });
    });

    group('removeNode', () {
      test('removes an existing node', () {
        final newState = nodeService.removeNode(initialState, 'node1');
        expect(newState.nodes.length, 1);
        expect(newState.nodes.containsKey('node1'), isFalse);
      });

      test('removes node from index', () {
        final newState = nodeService.removeNode(initialState, 'node1');
        expect(newState.nodeIndex.getNode('node1'), isNull);
        expect(newState.nodeIndex.getNode('node2'), isNotNull);
      });

      test('removes node from selection', () {
        final selectedState =
            initialState.copyWith(selectedNodes: {'node1', 'node2'});
        final newState = nodeService.removeNode(selectedState, 'node1');

        expect(newState.selectedNodes, isNot(contains('node1')));
        expect(newState.selectedNodes, contains('node2'));
      });
    });

    group('moveNodes', () {
      test('moves a single node by a delta', () {
        const delta = Offset(50, -20);
        final newState = nodeService.moveNodes(initialState, {'node1'}, delta);
        expect(newState.nodes['node1']!.position, const Offset(150, 80));
      });

      test('moves multiple nodes by a delta', () {
        const delta = Offset(50, -20);
        final newState =
            nodeService.moveNodes(initialState, {'node1', 'node2'}, delta);

        expect(newState.nodes['node1']!.position, const Offset(150, 80));
        expect(newState.nodes['node2']!.position, const Offset(350, 180));
      });

      test('updates node index after moving', () {
        const delta = Offset(50, -20);
        final newState = nodeService.moveNodes(initialState, {'node1'}, delta);
        expect(newState.nodeIndex.getNode('node1')!.position,
            const Offset(150, 80));
      });

      test('does not move non-draggable nodes', () {
        final nonDraggableNode = node1.copyWith(draggable: false);
        var stateWithNonDraggable = initialState.copyWith(
            nodes: {...initialState.nodes, 'node1': nonDraggableNode},
            nodeIndex: NodeIndex.fromNodes([nonDraggableNode, node2]));

        const delta = Offset(50, 50);
        final newState = nodeService.moveNodes(
            stateWithNonDraggable, {'node1', 'node2'}, delta);

        // node1 should not move
        expect(newState.nodes['node1']!.position, const Offset(100, 100));
        // node2 should move
        expect(newState.nodes['node2']!.position, const Offset(350, 250));
      });
    });

    group('updateNode', () {
      test('updates properties of an existing node', () {
        final updatedNode1 = node1.copyWith(
            position: const Offset(111, 222), size: const Size(80, 80));
        final newState = nodeService.updateNode(initialState, updatedNode1);

        expect(newState.nodes['node1']!.position, const Offset(111, 222));
        expect(newState.nodes['node1']!.size, const Size(80, 80));
        expect(newState.nodes['node2']!.position,
            const Offset(300, 200)); // Unchanged
      });

      test('updates the node index after update', () {
        final updatedNode1 = node1.copyWith(position: const Offset(111, 222));
        final newState = nodeService.updateNode(initialState, updatedNode1);

        // Check new position in index
        final newRect = Rect.fromCenter(
            center: const Offset(111, 222), width: 100, height: 50);
        expect(newState.nodeIndex.queryNodesInRect(newRect), contains('node1'));

        // Check old position in index
        expect(newState.nodeIndex.queryNodesInRect(node1.rect), isEmpty);
      });
    });

    group('resizeNode', () {
      test('bottomRight preserves topLeft and changes size', () {
        const delta = Offset(20, 30); // 20 wider, 30 taller
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.bottomRight, delta);

        final oldNode = initialState.nodes['node1']!;
        final newNode = newState.nodes['node1']!;

        expect(newNode.size, const Size(120, 80));
        // Top-left corner should be the same
        expect(newNode.topLeft, equals(oldNode.topLeft));
        // Center (position) must have changed
        expect(newNode.position, const Offset(110, 115));
      });

      test('topLeft changes topLeft and size, preserves bottomRight', () {
        const delta = Offset(-20, -30); // 20 wider, 30 taller (negative delta)
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.topLeft, delta);

        final oldNode = initialState.nodes['node1']!;
        final newNode = newState.nodes['node1']!;

        expect(newNode.size, const Size(120, 80));
        // Bottom-right corner should be the same
        expect(newNode.bottomRight, equals(oldNode.bottomRight));
        // Center (position) must have changed
        expect(newNode.position, const Offset(90, 85));
      });

      test('right preserves left and changes size/position', () {
        const delta = Offset(40, 0);
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.right, delta);

        final oldNode = initialState.nodes['node1']!;
        final newNode = newState.nodes['node1']!;

        expect(newNode.size, const Size(140, 50));
        expect(newNode.topLeft.dy, equals(oldNode.topLeft.dy));
        expect(newNode.topLeft.dx, equals(oldNode.topLeft.dx));
        expect(newNode.position, const Offset(120, 100));
      });

      test('left preserves right and changes size/position', () {
        const delta = Offset(-30, 0);
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.left, delta);

        final oldNode = initialState.nodes['node1']!;
        final newNode = newState.nodes['node1']!;

        expect(newNode.size, const Size(130, 50));
        expect(newNode.bottomRight.dy, equals(oldNode.bottomRight.dy));
        expect(newNode.bottomRight.dx, equals(oldNode.bottomRight.dx));
        expect(newNode.position, const Offset(85, 100));
      });

      test('bottomRight respects minSize', () {
        const delta = Offset(-200, -200); // Try to make it negative size
        const minSize = Size(50, 50);
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.bottomRight, delta,
            minSize: minSize);

        final newNode = newState.nodes['node1']!;

        // Size should be clamped to minSize
        expect(newNode.size, equals(minSize));
        // Top-left should still be preserved
        expect(newNode.topLeft, equals(initialState.nodes['node1']!.topLeft));
      });

      test('topLeft respects minSize', () {
        const delta = Offset(200, 200); // Try to make it negative size
        const minSize = Size(50, 50);
        final newState = nodeService.resizeNode(
            initialState, 'node1', ResizeDirection.topLeft, delta,
            minSize: minSize);

        final newNode = newState.nodes['node1']!;

        // Size should be clamped to minSize
        expect(newNode.size, equals(minSize));
        // Bottom-right should still be preserved
        expect(newNode.bottomRight,
            equals(initialState.nodes['node1']!.bottomRight));
      });
    });
  });
}
