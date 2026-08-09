enum ContentType { video, short, article, post, audio, art, announcement, poll }

class ContentItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String sourceUrl; // internal only — never render this in the UI
  final ContentType type;
  final DateTime publishedAt;
  final String? description;

  ContentItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.sourceUrl,
    required this.type,
    required this.publishedAt,
    this.description,
  });

  String get typeLabel {
    switch (type) {
      case ContentType.video:
        return 'ভিডিও';
      case ContentType.short:
        return 'শর্টস';
      case ContentType.article:
        return 'আর্টিকেল';
      case ContentType.post:
        return 'পোস্ট';
      case ContentType.audio:
        return 'অডিও';
      case ContentType.art:
        return 'আর্ট';
      case ContentType.announcement:
        return 'ঘোষণা';
      case ContentType.poll:
        return 'পোল';
    }
  }
}
