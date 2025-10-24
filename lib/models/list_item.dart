class ListItem {
  String id;
  String text;
  bool completed;

  ListItem({required this.id, required this.text, this.completed = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'completed': completed,
  };

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
    id: json['id'] as String,
    text: json['text'] as String,
    completed: json['completed'] as bool,
  );
}
