class Note {
  final String id;
  String title;
  String content;

  Note({required this.id, required this.title, required this.content});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'].toString(),  // int en Java → String en Dart
    title: json['nombre'] ?? '',
    content: json['contenido'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': int.parse(id),   // String en Dart → int en Java
    'nombre': title,
    'contenido': content,
  };
}