import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/content_item.dart';
import '../services/youtube_service.dart';
import '../services/blog_service.dart';
import '../widgets/content_card.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _youtube = YoutubeService();
  final _blog = BlogService();

  List<ContentItem> _videos = [];
  List<ContentItem> _articles = [];
  bool _loading = true;
  bool _offline = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final connectivity = await Connectivity().checkConnectivity();
    final online = !connectivity.contains(ConnectivityResult.none);

    if (!online) {
      setState(() {
        _offline = true;
        _loading = false;
      });
      return;
    }

    try {
      final results = await Future.wait([
        _youtube.fetchLatest(maxResults: 3),
        _blog.fetchLatest(maxResults: 3),
      ]);
      setState(() {
        _offline = false;
        _videos = results[0];
        _articles = results[1];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'কনটেন্ট লোড করা যায়নি। আবার চেষ্টা করুন।';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tropelon'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHome),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHome,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (_offline) _offlineBanner(),
                  if (_error != null) Text(_error!),
                  _sectionHeader('সাম্প্রতিক ভিডিও', 'video'),
                  ..._videos.map((v) => ContentCard(item: v, isOffline: _offline)),
                  const SizedBox(height: 16),
                  _sectionHeader('সাম্প্রতিক আর্টিকেল', 'article'),
                  ..._articles.map((a) => ContentCard(item: a, isOffline: _offline)),
                  const SizedBox(height: 24),
                  Center(
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MoreScreen()),
                      ),
                      child: const Text('আরও দেখুন'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _offlineBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'অফলাইন — সংরক্ষিত থাম্বনেইল দেখানো হচ্ছে। নতুন কনটেন্ট দেখতে ইন্টারনেটে সংযুক্ত হন।',
      ),
    );
  }

  Widget _sectionHeader(String title, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
