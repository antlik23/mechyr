import 'dart:convert';

class Pagination {
  int count;
  int page;
  int? next;
  int pages;
  int items;

  Pagination({
    required this.count,
    required this.page,
    this.next,
    required this.pages,
    required this.items,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        count: json["count"],
        page: json["page"],
        next: json["next"],
        pages: json["pages"],
        items: json["items"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "page": page,
        "next": next,
        "pages": pages,
        "items": items,
      };
}
