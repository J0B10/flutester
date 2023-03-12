
enum FlowDirection {
  left,
  right,
  none;

  FlowDirection invert() {
    switch (this) {
      case FlowDirection.left:
        return FlowDirection.right;
      case FlowDirection.right:
        return FlowDirection.left;
      default:
        return FlowDirection.none;
    }
  }

  static FlowDirection of(double val) {
    if (val > 0) {
      return FlowDirection.right;
    } else if (val < 0) {
      return FlowDirection.left;
    } else {
      return FlowDirection.none;
    }
  }
}