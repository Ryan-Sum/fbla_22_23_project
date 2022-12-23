import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String author;
  final String caption;
  final String imageUrl;
  final DateTime date;
  final bool isApproved;
  final List<dynamic> likes;
  final String id;

  Post({
    required this.author,
    required this.caption,
    required this.date,
    required this.imageUrl,
    required this.isApproved,
    required this.likes,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'author': author,
        'caption': caption,
        'date': date,
        'imageUrl': imageUrl,
        'isApproved': isApproved,
        'likes': likes,
        'id': id,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        author: json['author'],
        caption: json['caption'],
        date: (json['date'] as Timestamp).toDate(),
        imageUrl: json['imageUrl'],
        isApproved: json['isApproved'],
        likes: json['likes'],
        id: json['id'],
      );
}
