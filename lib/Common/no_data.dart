import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
import 'package:flutter_snippet/generated/my_images.dart';

class NoData extends StatelessWidget {
  final String? message;

  const NoData({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: const Image(
            image: AssetImage(MyImages.imagesNoTask),
            width: 100,
            height: 100,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          alignment: Alignment.center,
          child: Text(message ?? "暂无信息~"),
        ),
      ],
    );
  }
}

class MyCircularProgress extends StatelessWidget {
  final Color color;
  final Animation<Color?>? valueColor;

  const MyCircularProgress({super.key, this.color = MyColors.mainColor, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        valueColor: valueColor,
      ),
    );
  }
}
