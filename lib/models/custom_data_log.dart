import 'dart:convert';

class CustomDataLog {
  final int? id;
  final bool isDone;
  final String title, url, method;
  final Map header, body, response;
  final DateTime createdAt, updatedAt;

  CustomDataLog({
    this.id,
    required this.isDone,
    required this.title,
    required this.url,
    required this.method,
    required this.header,
    required this.body,
    required this.response,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomDataLog.fromJson(Map<String, dynamic> json) {
    return CustomDataLog(
      id: json['id'],
      isDone: json['isDone'] == 1,
      title: json['title'],
      url: json['url'],
      method: json['method'],
      header: jsonDecode(json['header']),
      body: jsonDecode(json['body']),
      response: jsonDecode(json['response']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'isDone': isDone ? 1 : 0,
      'title': title,
      'url': url,
      'method': method,
      'header': jsonEncode(header),
      'body': jsonEncode(body),
      'response': jsonEncode(response),
      'createdAt': '$createdAt',
      'updatedAt': '$updatedAt',
    };
  }

  CustomDataLog copyWith({
    int? id,
    bool? isDone,
    String? title,
    String? url,
    String? method,
    Map? header,
    Map? body,
    Map? response,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomDataLog(
      id: id ?? this.id,
      isDone: isDone ?? this.isDone,
      title: title ?? this.title,
      url: url ?? this.url,
      method: method ?? this.method,
      header: header ?? this.header,
      body: body ?? this.body,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is CustomDataLog &&
        other.runtimeType == runtimeType &&
        other.id == id);
  }

  @override
  int get hashCode => Object.hash(id, title);
}
