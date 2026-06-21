class BlogAuthor {
  final String id;
  final String name;
  final String role;
  final String bio;
  final String imageUrl;

  const BlogAuthor({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.imageUrl,
  });
}

class BlogArticle {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String category;
  final List<String> tags;
  final DateTime publishedAt;
  final int readMinutes;
  final int views;
  final int comments;
  final bool featured;
  final String imageUrl;
  final BlogAuthor author;

  const BlogArticle({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.category,
    required this.tags,
    required this.publishedAt,
    required this.readMinutes,
    required this.views,
    required this.comments,
    required this.featured,
    required this.imageUrl,
    required this.author,
  });

  String searchableText() {
    return <String>[
      title,
      excerpt,
      content,
      category,
      author.name,
      ...tags,
    ].join(' ').toLowerCase();
  }
}

class AuthorStats {
  final BlogAuthor author;
  final int articleCount;

  const AuthorStats({required this.author, required this.articleCount});
}

class TopicStat {
  final String topic;
  final int mentions;

  const TopicStat({required this.topic, required this.mentions});
}
