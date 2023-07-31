/*
* Created By Mirai Devs.
* On 28/7/2023.
*/

import 'package:uuid/uuid.dart';

import 'book_model.dart';

class Quote {
  final String id;
  final String content;
  Book? book;

  Quote({
    required this.id,
    required this.content,
    this.book,
  });

  factory Quote.create({required String content, Book? book}) {
    final String id = const Uuid().v1();
    return Quote(id: id, content: content, book: book);
  }

  factory Quote.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return Quote(
      id: json['id'],
      content: json['content'],
      book: json['book'] == null ? null : Book.fromJson(json['book']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'content': content,
        'book': book?.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          book == other.book;

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ book.hashCode;

  @override
  String toString() {
    return 'Quote{id: $id, content: $content, book: $book}';
  }
}
