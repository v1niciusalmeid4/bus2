class TimezoneModel {
  final String offset;
  final String description;

  TimezoneModel({
    required this.offset,
    required this.description,
  });

  factory TimezoneModel.fromMap(dynamic map) {
    return TimezoneModel(
      offset: map['offset'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'offset': offset,
      'description': description,
    };
  }
}
