class NameModel {
  final String title;
  final String first;
  final String last;

  NameModel({
    required this.title,
    required this.first,
    required this.last,
  });

  factory NameModel.fromMap(dynamic map) {
    return NameModel(
      title: map['title'] as String,
      first: map['first'] as String,
      last: map['last'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }
}
