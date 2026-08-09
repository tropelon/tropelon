import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/content_item.dart';

/// Fetches the latest posts from the Tropelon BD Blogger site
/// (tropelon.blogspot.com) using its public RSS feed. No API key needed.
class BlogService {
  static const String feedUrl =
      'https://tropelon.blogspot.com/feeds/posts/default?alt=rss';

  Future<List<ContentItem>> fetchLatest({int maxResults = 10}) async {
    final response = await http.get(Uri.parse(feedUrl));
    if (response.statusCode != 200) {
      throw Exception('Blog feed error: ${response.statusCode}');
    }

    final document = XmlDocument.parse(response.body);
    final items = document.findAllElements('item').take(maxResults);

    return items.map((item) {
      final title = item.findElements('title').first.innerText;
      final link = item.findElements('link').first.innerText;
      final pubDateStr = item.findElements('pubDate').first.innerText;
      final guid = item.findElements('guid').first.innerText;

      // try to pull a thumbnail out of the content:encoded HTML, else fallback
      String thumb = 'https://via.placeholder.com/480x270.png?text=Tropelon';
      final contentEls = item.findElements('content:encoded');
      if (contentEls.isNotEmpty) {
        final html = contentEls.first.innerText;
        final match = RegExp(r'<img[^>]+src="([^"]+)"').firstMatch(html);
        if (match != null) thumb = match.group(1)!;
      }

      DateTime published;
      try {
        published = HttpDate.parse(pubDateStr);
      } catch (_) {
        published = DateTime.now();
      }

      return ContentItem(
        id: guid,
        title: title,
        thumbnailUrl: thumb,
        sourceUrl: link,
        type: ContentType.article,
        publishedAt: published,
      );
    }).toList();
  }
}

/// Minimal RFC 1123 date parser so we don't need an extra package.
class HttpDate {
  static DateTime parse(String value) {
    return DateTime.parse(
      Uri.decodeComponent(value).contains(',')
          ? _toIso(value)
          : value,
    );
  }

  static String _toIso(String rfc1123) {
    // Fallback: let DateTime try; if it fails, caller catches and uses now().
    final parts = rfc1123.split(' ');
    // Very small parser for common "EEE, dd MMM yyyy HH:mm:ss Z" format.
    const months = {
      'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
      'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
      'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
    };
    if (parts.length >= 5 && months.containsKey(parts[2])) {
      final day = parts[1].padLeft(2, '0');
      final month = months[parts[2]];
      final year = parts[3];
      final time = parts[4];
      return '$year-$month-${day}T$time';
    }
    throw const FormatException('unrecognized date');
  }
}
