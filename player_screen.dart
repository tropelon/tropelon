import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/content_item.dart';

class PlayerScreen extends StatefulWidget {
  final ContentItem item;
  final bool isOffline;

  const PlayerScreen({super.key, required this.item, this.isOffline = false});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late WebViewController _controller;
  bool _loading = true;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectionAndLoad();
  }

  Future<void> _checkConnectionAndLoad() async {
    final result = await Connectivity().checkConnectivity();
    final online = !result.contains(ConnectivityResult.none);

    if (!online) {
      setState(() {
        _offline = true;
        _loading = false;
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
        ),
      )
      ..loadRequest(Uri.parse(_embedUrl(widget.item)));
  }

  /// Builds an embeddable URL so playback stays inside the app.
  /// The raw source URL itself is never shown in the UI.
  String _embedUrl(ContentItem item) {
    if (item.type == ContentType.video || item.type == ContentType.short) {
      final uri = Uri.tryParse(item.sourceUrl);
      final videoId = uri?.queryParameters['v'] ?? item.id;
      return 'https://www.youtube.com/embed/$videoId?autoplay=1&rel=0';
    }
    return item.sourceUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _offline
          ? _buildOfflineMessage()
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading) const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }

  Widget _buildOfflineMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'এই কনটেন্ট দেখতে ইন্টারনেট সংযোগ প্রয়োজন।\nঅনুগ্রহ করে ইন্টারনেটের সাথে সংযুক্ত হন।',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkConnectionAndLoad,
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
