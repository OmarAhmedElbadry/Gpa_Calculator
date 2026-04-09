import 'dart:convert';

class Grade {
  final String letter;
  final double value;

  Grade({
    required this.letter,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'letter': letter,
      'value': value,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      letter: map['letter'],
      value: map['value'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Grade.fromJson(String source) => Grade.fromMap(json.decode(source));

  Grade copyWith({
    String? letter,
    double? value,
  }) {
    return Grade(
      letter: letter ?? this.letter,
      value: value ?? this.value,
    );
  }
}
