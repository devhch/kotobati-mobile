/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

class Book {
  final String? id;
  final String? title;
  final String? longTitle;
  final String? author;
  final String? description;
  final String? image;
  String? path;
  final List<String> notes;
  final List<String> quotes;

  Book({
    this.id,
    this.title,
    this.longTitle,
    this.author,
    this.description,
    this.image,
    this.path,
    this.notes = const <String>[],
    this.quotes = const <String>[],
  });

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
        'notes': notes,
        'quotes': quotes,
      };

  @override
  String toString() {
    return 'Book{id: $id, title: $title, longTitle: $longTitle, author: $author description: $description, image: $image, path: $path, notes: $notes, quotes: $quotes}';
  }
}
