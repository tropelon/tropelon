import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/content_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সব কনটেন্ট')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: SampleData.items.length,
        itemBuilder: (_, i) => ContentCard(item: SampleData.items[i]),
      ),
    );
  }
}

// NOTE: এখন এখানে শুধু sample_data.dart-এর ডেমো কনটেন্ট দেখানো হচ্ছে।
// পরে YouTube/Blog/Facebook থেকে লাইভ কনটেন্ট আনতে এখানে একটা
// service (fetch) কল যোগ করা হবে।
