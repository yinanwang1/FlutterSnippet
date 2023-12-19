// 地图的Marker上编写内容。 现在有2种 （1）单车或还车点的图标。（2）还车点名称的气泡图标
enum MarkerTitleType {
  small(width: 40, height: 40),
  big(width: 100, height: 30);

  final double width;
  final double height;

  const MarkerTitleType({required this.width, required this.height});

  static MarkerTitleType convert(int value) {
    if (value < MarkerTitleType.values.length) {
      return MarkerTitleType.values[value];
    } else {
      return MarkerTitleType.small;
    }
  }
}
