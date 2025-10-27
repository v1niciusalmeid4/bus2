class DobModel {
  final String date;
  final int age;

  DobModel({
    required this.date,
    required this.age,
  });

  factory DobModel.fromMap(dynamic map) {
    return DobModel(
      date: map['date'] as String,
      age: map['age'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'date': date,
    };
  }
}
