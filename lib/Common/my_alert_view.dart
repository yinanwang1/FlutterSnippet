import 'package:flutter/material.dart';
import 'package:flutter_snippet/Common/my_colors.dart';
class MyAlertView extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final String? leftTitle;
  final String? rightTitle;
  final GestureTapCallback? onClickLeft;
  final GestureTapCallback? onClickRight;

  const MyAlertView({
    this.title,
    this.titleWidget,
    this.content,
    this.leftTitle,
    this.rightTitle,
    this.onClickLeft,
    this.onClickRight,
    this.contentWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const blurRadius = 15.0;

    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width - 50,
          decoration:
              const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(blurRadius)), boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: blurRadius,
            )
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(),
              _content(),
              const Padding(padding: EdgeInsets.only(top: 10)),
              _buttons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      margin:
          (null == title && null == titleWidget) ? EdgeInsets.zero : const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
      child: null == titleWidget
          ? Text(
              title ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(color: MyColors.title, fontSize: 18, fontWeight: FontWeight.w600),
            )
          : titleWidget ?? Container(),
    );
  }

  Widget _content() {
    return Container(
      margin:
          (null == title && null == titleWidget) ? EdgeInsets.zero : const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: null == contentWidget
          ? Text(
              content ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(color: MyColors.subtitle, fontSize: 14, fontWeight: FontWeight.w400),
            )
          : contentWidget ?? Container(),
    );
  }

  Widget _buttons() {
    if (null != leftTitle && null != rightTitle) {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 20),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: onClickLeft,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                  ),
                  child: Text(
                    leftTitle ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: MyColors.title),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: onClickRight,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                  ),
                  child: Text(
                    rightTitle ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (null != leftTitle) {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 20),
        child: Container(
          height: 38,
          constraints: const BoxConstraints(minWidth: 200),
          child: ElevatedButton(
            onPressed: onClickLeft,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
            ),
            child: Text(
              leftTitle ?? "",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
