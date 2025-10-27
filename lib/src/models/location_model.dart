import 'package:bus2/src/models/models.dart';

class LocationModel {
  final StreetModel street;
  final String city;
  final String state;
  final String country;
  final dynamic postcode;
  final CoordinatesModel coordinates;
  final TimezoneModel timezone;

  LocationModel({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.coordinates,
    required this.timezone,
  });

  factory LocationModel.fromMap(dynamic map) {
    return LocationModel(
      street: StreetModel.fromMap(map['street']),
      city: map['city'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      postcode: map['postcode'],
      coordinates: CoordinatesModel.fromMap(map['coordinates']),
      timezone: TimezoneModel.fromMap(map['timezone']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street.toMap(),
      'city': city,
      'state': state,
      'country': country,
      'postcode': postcode,
      'coordinates': coordinates.toMap(),
      'timezone': timezone.toMap(),
    };
  }
}
