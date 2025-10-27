enum DragMode { none, canvas, node, edge, selection, connection }

enum HandlePosition { top, right, bottom, left }

enum HandleType { both, source, target }

enum EdgePathType { bezier, step, straight, smoothStep }

enum BackgroundVariant {
  dots, // index 0
  grid, // index 1
  cross, // index 2
  none, // index 3 (or wherever)
}

enum ControlPanelAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center
}

enum ThemeCategory {
  professional,
  creative,
  accessibility,
  technical,
  gaming,
  custom,
}

enum NodeEventType {
  click,
  doubleClick,
  dragStart,
  drag,
  dragStop,
  mouseEnter,
  mouseMove,
  mouseLeave,
  contextMenu,
  delete,
  change,
}

enum ConnectionLineType {
  bezier,
  straight,
  step,
  smoothStep,
  simpleBezier,
}

enum FitViewInterpolation {
  smooth,
  linear,
}

enum PanOnScrollMode {
  free,
  vertical,
  horizontal,
}

enum SelectionMode {
  partial,
  full,
}

enum ConnectionMode {
  strict,
  loose,
}

enum KeyboardAction {
  selectAll,
  deselectAll,
  deleteSelection,
  moveUp,
  moveDown,
  moveLeft,
  moveRight,
  zoomIn,
  zoomOut,
  resetZoom,
  duplicateSelection,
  undo,
  redo,
}

enum DefaultNodeType {
  defaultNode,
  inputNode,
  outputNode,
}

enum ConnectionValidity {
  valid,
  invalid,
  none,
}
