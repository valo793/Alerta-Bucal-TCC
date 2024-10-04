import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/web_services.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewService webViewService;
  String currentUrl = 'https://youtube.com'; // URL inicial padrão
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Passa o context para o serviço
    webViewService = WebViewService(
      context: context,
      onPageFinished: _handlePageFinished,
    );
    webViewService.controller.loadRequest(Uri.parse(currentUrl));
  }

  // Função chamada quando o carregamento da página termina
  void _handlePageFinished(String url) {
    setState(() {
      isLoading = false;
    });
  }

  // Função para carregar uma nova URL no WebView
  void loadSite(String url) {
    setState(() {
      isLoading = true;
      currentUrl = url;
      webViewService.loadUrl(currentUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () => loadSite('https://www.youtube.com'),
            child: const Text('YouTube'),
          ),
          ElevatedButton(
            onPressed: () => loadSite('https://www.youtubekids.com'),
            child: const Text('YouTube Kids'),
          ),
          ElevatedButton(
            onPressed: () => loadSite('https://www.tiktok.com'),
            child: const Text('TikTok'),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: webViewService.controller,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
