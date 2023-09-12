/*
* Created By Mirai Devs.
* On 28/7/2023.
*/
import 'package:uuid/uuid.dart';

import 'book_model.dart';

class Note {
  final String id;
  final String content;
  int page;
  Book? book;

  Note({
    required this.id,
    required this.content,
    this.book,
    this.page = 0,
  });

  factory Note.create({required String content, required int page, Book? book}) {
    final String id = const Uuid().v1();
    return Note(id: id, content: content, page: page, book: book);
  }

  factory Note.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return Note(
      id: json['id'],
      content: json['content'],
      page: json['page'] ?? 0,
      book: json['book'] == null ? null : Book.fromJson(json['book']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'content': content,
        'page': page,
        'book': book?.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          page == other.page &&
          book == other.book;

  @override
  int get hashCode => id.hashCode ^ content.hashCode ^ page.hashCode ^ book.hashCode;

  @override
  String toString() {
    return 'Note{id: $id, content: $content, page: $page, book: $book}';
  }
}
