import 'package:flutter/material.dart';

/// 一行显示左边的图标，标题，和右边的尾部组件
/// leading 为左边图标，可以不出现
/// title 标题的组件
/// trailing 右边的组件

class NormalCell extends StatelessWidget {
  const NormalCell(
      {Key? key, this.height = 50, this.leading, this.title, this.middle, this.trailing, this.showBottomLine = true, this.onTap})
      : super(key: key);

  final double height;
  final Widget? leading;
  final Widget? title;
  final Widget? middle;
  final Widget? trailing;
  final bool showBottomLine;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  null != leading
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: leading,
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 15),
                        ),
                  null != title ? title! : Container(),
                  Expanded(
                      child: null != middle
                          ? Center(
                              child: middle!,
                            )
                          : Container()),
                  null != trailing
                      ? Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: trailing!,
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 15),
                        ),
                ],
              ),
            ),
            showBottomLine
                ? const Divider(
                    indent: 15,
                    endIndent: 15,
                    height: 1,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
