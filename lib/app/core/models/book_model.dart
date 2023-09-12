/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

import 'dart:io';
import 'dart:ui';

import 'package:kotobati/app/core/models/note_model.dart';

import 'planing_books_model.dart';
import 'quote_model.dart';

class Book {
  final String id;
  final String? title;
  final String? longTitle;
  final String? author;
  final String? description;
  dynamic image;
  String? path;
  List<Note>? notes;
  List<Quote>? quotes;
  PlaningBooksModel? planingBook;
  int savedPage;

  Book({
    required this.id,
    this.title,
    this.longTitle,
    this.author,
    this.description,
    this.image,
    this.path,
    this.planingBook,
    this.notes,
    this.quotes,
    this.savedPage = 0,
  }) {
    notes ??= <Note>[];
    quotes ??= <Quote>[];
  }

  factory Book.fromJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(map);

    final List<Note> notes = <Note>[];
    if (json['notes'] != null) {
      for (int i = 0; i < json['notes'].length; i++) {
        notes.add(Note.fromJson(json['notes'][i]));
      }
    }

    final List<Quote> quotes = <Quote>[];
    if (json['quotes'] != null) {
      for (int i = 0; i < json['quotes'].length; i++) {
        quotes.add(Quote.fromJson(json['quotes'][i]));
      }
    }

    return Book(
      id: json['id'],
      title: json['title'],
      longTitle: json['longTitle'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      path: json['path'],
      savedPage: json['savedPage'] ?? 0,
      planingBook:
          json['planingBook'] != null ? PlaningBooksModel.fromJson(json['planingBook']) : null,
      notes: notes,
      quotes: quotes,
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
        'savedPage': savedPage,
        'planingBook': planingBook?.toJson(),
        'notes': notes?.map((Note note) => note.toJson()).toList(),
        'quotes': quotes?.map((Quote quote) => quote.toJson()).toList(),
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
    return 'Book{id: $id, title: $title, longTitle: $longTitle, author: $author, description: $description, image: $image, path: $path, notes: $notes, quotes: $quotes, planingBook: $planingBook}';
  }
}
