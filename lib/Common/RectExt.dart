
import 'dart:ui';

extension RectExt on Rect {
  Rect clone(
      {double? left,
        double? top,
        double? right,
        double? bottom,
        double? width,
        double? height}) {
    if (right != null || bottom != null) {
      return Rect.fromLTRB(left ?? this.left, top ?? this.top,
          right ?? this.right, bottom ?? this.bottom);
    }

    if (width != null || height != null) {
      return Rect.fromLTWH(left ?? this.left, top ?? this.top,
          width ?? this.width, height ?? this.height);
    }

    return Rect.fromLTRB(this.left, this.top, this.right, this.bottom);
  }
}