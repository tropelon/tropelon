import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_item.dart';

/// Fetches the latest uploads from the Tropelon BD YouTube channel.
///
/// You need a free YouTube Data API v3 key from
/// https://console.cloud.google.com/apis/credentials
/// and the channel's "uploads" playlist ID (starts with "UU...").
/// Find it by replacing the "UC" at the start of your Channel ID with "UU".
class YoutubeService {
  static const String apiKey = 'YOUR_YOUTUBE_API_KEY_HERE';
  static const String uploadsPlaylistId = 'YOUR_UPLOADS_PLAYLIST_ID_HERE';

  Future<List<ContentItem>> fetchLatest({int maxResults = 10}) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/playlistItems'
      '?part=snippet,contentDetails'
      '&maxResults=$maxResults'
      '&playlistId=$uploadsPlaylistId'
      '&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('YouTube API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final items = (data['items'] as List<dynamic>? ?? []);

    return items.map((item) {
      final snippet = item['snippet'];
      final videoId = item['contentDetails']['videoId'];
      final title = snippet['title'] as String;
      final thumb = snippet['thumbnails']['high']?['url'] ??
          snippet['thumbnails']['default']['url'];
      final publishedAt = DateTime.parse(snippet['publishedAt']);
      // crude heuristic: Shorts titles/descriptions often contain #shorts
      final isShort = (snippet['description'] as String? ?? '')
              .toLowerCase()
              .contains('#shorts') ||
          title.toLowerCase().contains('#shorts');

      return ContentItem(
        id: videoId,
        title: title,
        thumbnailUrl: thumb,
        sourceUrl: 'https://www.youtube.com/watch?v=$videoId',
        type: isShort ? ContentType.short : ContentType.video,
        publishedAt: publishedAt,
        description: snippet['description'],
      );
    }).toList();
  }
}
