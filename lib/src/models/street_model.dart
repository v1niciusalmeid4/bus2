class StreetModel {
  final int number;
  final String name;

  StreetModel({
    required this.number,
    required this.name,
  });

  factory StreetModel.fromMap(dynamic map) {
    return StreetModel(
      number: map['number'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
    };
  }
}
