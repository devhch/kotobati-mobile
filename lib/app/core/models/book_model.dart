/*
* Created By Mirai Devs.
* On 6/23/2023.
*/

class BookModel {
  String? id;
  String? title;
  String? author;
  String? image;
  List<String> notes;
  List<String> quotes;

  BookModel({
    this.id,
    this.title,
    this.author,
    this.image,
    this.notes = const <String>[],
    this.quotes = const <String>[],
  });
}
