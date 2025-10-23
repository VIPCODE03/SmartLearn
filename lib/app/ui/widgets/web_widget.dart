import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WIDWeb extends StatefulWidget {
  final String url;
  const WIDWeb({super.key, required this.url});

  @override
  State<WIDWeb> createState() => _WIDWebState();
}

class _WIDWebState extends State<WIDWeb> {
  final cache = WebViewCache();
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  Future<void> _setupController() async {
    _controller = await cache.getController(widget.url);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.design_services_outlined),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller!),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: context.style.color.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // KHÔNG xoá controller => giữ lại trạng thái
    super.dispose();
  }
}

class WebViewCache {
  static final WebViewCache _instance = WebViewCache._internal();
  factory WebViewCache() => _instance;
  WebViewCache._internal();

  WebViewController? controller;
  String? lastUrl;

  Future<WebViewController> getController(String url) async {
    if (controller != null) return controller!;
    final c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate())
      ..loadRequest(Uri.parse(url));
    controller = c;
    lastUrl = url;
    return c;
  }

  void clear() {
    controller = null;
    lastUrl = null;
  }
}
