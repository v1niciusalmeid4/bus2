class CoordinatesModel {
  final String lat;
  final String long;

  CoordinatesModel({
    required this.lat,
    required this.long,
  });

  factory CoordinatesModel.fromMap(dynamic map) {
    return CoordinatesModel(
      lat: map['latitude'] as String,
      long: map['longitude'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': lat,
      'longitude': long,
    };
  }
}
