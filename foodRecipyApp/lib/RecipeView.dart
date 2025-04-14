import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipeview extends StatefulWidget {
  final String url;


  // It's best practice to mark this constructor parameter as `required`.
  // Also note that you don't need `late` if you pass the value via constructor.
  const Recipeview({super.key, required this.url});

  @override
  State<Recipeview> createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {
  late final WebViewController _controller;
   late String finalUrl;
  @override
  void initState() {
    super.initState();
    if(widget.url.toString().contains("http://")){
      finalUrl=widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl=widget.url;
    }
    _controller = WebViewController()
    // 1) Set JavaScript mode
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // 2) Load your initial URL
      ..loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Food App"),
      ),
      // 3) Use WebViewWidget with the controller
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
