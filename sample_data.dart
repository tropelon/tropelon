import 'content_item.dart';

/// Placeholder content so the app builds and runs with zero setup.
/// Later, replace this with a real YouTube/Facebook/blog fetch.
class SampleData {
  static final List<ContentItem> items = [
    ContentItem(
      id: 'aqz-KE-bpKQ',
      title: 'ডেমো ভিডিও ১ — Big Buck Bunny',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon1/480/270',
      sourceUrl: 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
      type: ContentType.video,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ContentItem(
      id: 'demo-video-2',
      title: 'ডেমো ভিডিও ২ — টেক টক',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon2/480/270',
      sourceUrl: 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
      type: ContentType.video,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ContentItem(
      id: 'demo-video-3',
      title: 'ডেমো শর্টস — এআই নিয়ে',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon3/480/270',
      sourceUrl: 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
      type: ContentType.short,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ContentItem(
      id: 'demo-article-1',
      title: 'ডেমো আর্টিকেল ১ — ডিজিটাল ইনোভেশন',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon4/480/270',
      sourceUrl: 'https://flutter.dev',
      type: ContentType.article,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ContentItem(
      id: 'demo-article-2',
      title: 'ডেমো আর্টিকেল ২ — এআই কী ও কেন',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon5/480/270',
      sourceUrl: 'https://flutter.dev',
      type: ContentType.article,
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ContentItem(
      id: 'demo-post-1',
      title: 'ডেমো পোস্ট — আপডেট',
      thumbnailUrl: 'https://picsum.photos/seed/tropelon6/480/270',
      sourceUrl: 'https://flutter.dev',
      type: ContentType.post,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
