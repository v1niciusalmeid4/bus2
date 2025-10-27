class IdModel {
  final String name;
  final String? value;

  IdModel({
    required this.name,
    required this.value,
  });

  factory IdModel.fromMap(dynamic map) {
    return IdModel(
      name: map['name'] as String,
      value: map['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }
}
