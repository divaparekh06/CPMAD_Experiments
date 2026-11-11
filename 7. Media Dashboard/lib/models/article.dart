class Article {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String timeAgo;
  final bool isFeatured;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.timeAgo,
    this.isFeatured = false,
  });
}
