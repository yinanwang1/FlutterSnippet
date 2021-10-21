import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


/// 展示网页
/// 依赖webview_flutter: ^2.1.1
/// @author 阿南
/// @since 2021/10/21 20:19

class FlutterWebView extends StatefulWidget {
  final String url;
  final String title;

  const FlutterWebView(this.url, {this.title = "", Key? key}) : super(key: key);

  @override
  _FlutterWebViewState createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
