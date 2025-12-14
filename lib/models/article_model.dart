// article_model.dart

class ArticleModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String date;
  final String author;
  final int? userId;

  final DateTime? createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.author,
    this.userId,
    this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date is String) {
        return DateTime.tryParse(date);
      }
      return null;
    }

    return ArticleModel(
      id: json['id'] as int,

      title: (json['judul'] as String?) ?? 'No Title',
      description: (json['konten'] as String?) ?? 'No Content',
      image: (json['gambar'] as String?) ?? 'placeholder',
      date: (json['tanggal'] as String?) ?? 'N/A',
      author: (json['penulis'] as String?) ?? 'Admin',

      userId: json['user_id'] as int?,
      createdAt: parseDate(json['created_at']),
    );
  }
}
