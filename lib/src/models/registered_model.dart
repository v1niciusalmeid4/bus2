class RegisteredModel {
  final String date;
  final int age;

  RegisteredModel({
    required this.date,
    required this.age,
  });

  factory RegisteredModel.fromMap(dynamic map) {
    return RegisteredModel(
      age: map['age'] as int,
      date: map['date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'date': date,
    };
  }
}
