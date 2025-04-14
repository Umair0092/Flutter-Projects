class NewsModel {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  NewsModel({
    this.title="",
    this.description="",
     this.url="",
     this.urlToImage="",
  });

  factory NewsModel.fromMap(Map<String, dynamic> news) {
    return NewsModel(
      title: news["title"]?.toString() ?? 'new headline',
      description: news["description"]?.toString() ?? 'No description',
      url: news["url"]?.toString() ?? 'https://default.url',
      urlToImage: news["urlToImage"]?.toString() ?? 'https://default.image',
    );
  }
}

class NewsModel2 {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  NewsModel2({
    this.title="",
    this.description="",
    this.url="",
    this.urlToImage="",
  });

  factory NewsModel2.fromMap(Map<String, dynamic> news) {
    return NewsModel2(
      title: news["title"]?.toString() ?? '',
      description: news["description"]?.toString() ?? '',
      url: news["url"]?.toString() ?? '',
      urlToImage: news["image"]?.toString() ?? '', // Note different key
    );
  }
}
