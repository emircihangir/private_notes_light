enum ViewMode { edit, view }

extension ViewModeX on ViewMode {
  ViewMode get next => ViewMode.values[(index + 1) % ViewMode.values.length];
}
