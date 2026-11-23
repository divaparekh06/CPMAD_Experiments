class Quote {
  final int id;
  final String text;
  final String author;

  Quote({required this.id, required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? 0,
      text: (json['quote'] ?? '').toString().trim(),
      author: (json['author'] ?? 'Unknown').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quote': text, 'author': author};
  }
}
