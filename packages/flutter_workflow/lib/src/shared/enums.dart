enum DragMode { none, canvas, node, selection, handle }

enum HandlePosition { top, right, bottom, left }

enum HandleType { both, source, target }

enum EdgePathType { bezier, step, straight }

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
