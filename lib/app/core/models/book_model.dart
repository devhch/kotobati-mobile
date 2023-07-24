/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'dart:io';
import 'dart:ui';

import 'planing_books_model.dart';

class Book {
  final String? id;
  final String? title;
  final String? longTitle;
  final String? author;
  final String? description;
  dynamic image;
  String? path;
  List<String>? notes;
  List<String>? quotes;
  PlaningBooksModel? planingBook;

  Book({
    this.id,
    this.title,
    this.longTitle,
    this.author,
    this.description,
    this.image,
    this.path,
    this.planingBook,
    this.notes,
    this.quotes,
  }) {
    notes ??= <String>[];
    quotes ??= <String>[];
  }

  factory Book.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    return Book(
      id: json['id'],
      title: json['title'],
      longTitle: json['longTitle'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      path: json['path'],
      planingBook:
          json['planingBook'] != null ? PlaningBooksModel.fromJson(json['planingBook']) : null,
      notes: json['notes'],
      quotes: json['quotes'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'longTitle': longTitle,
        'author': author,
        'description': description,
        'image': image,
        'path': path,
        'planingBook': planingBook?.toJson(),
        'notes': notes,
        'quotes': quotes,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          longTitle == other.longTitle &&
          author == other.author &&
          description == other.description &&
          image == other.image &&
          path == other.path &&
          notes == other.notes &&
          quotes == other.quotes &&
          planingBook == other.planingBook;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      longTitle.hashCode ^
      author.hashCode ^
      description.hashCode ^
      image.hashCode ^
      path.hashCode ^
      notes.hashCode ^
      quotes.hashCode ^
      planingBook.hashCode;

  @override
  String toString() {
    return 'Book{id: $id, title: $title, longTitle: $longTitle, author: $author, description: $description, path: $path, notes: $notes, quotes: $quotes, planingBook: $planingBook}';
  }
}
