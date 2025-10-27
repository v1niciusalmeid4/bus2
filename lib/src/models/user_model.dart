import 'package:bus2/src/models/models.dart';

class UserModel {
  final String gender;
  final NameModel name;
  final LocationModel location;
  final String email;
  final LoginModel login;
  final DobModel dob;
  final RegisteredModel registered;
  final String phone;
  final String cell;
  final IdModel id;
  final PictureModel picture;
  final String nat;

  UserModel({
    required this.gender,
    required this.name,
    required this.location,
    required this.login,
    required this.dob,
    required this.registered,
    required this.cell,
    required this.id,
    required this.picture,
    required this.email,
    required this.phone,
    required this.nat,
  });

  factory UserModel.fromMap(dynamic map) {
    return UserModel(
      gender: map['gender'] as String,
      name: NameModel.fromMap(map['name']),
      location: LocationModel.fromMap(map['location']),
      dob: DobModel.fromMap(map['dob']),
      registered: RegisteredModel.fromMap(map['registered']),
      phone: map['phone'] as String,
      cell: map['cell'] as String,
      id: IdModel.fromMap(map['id']),
      picture: PictureModel.fromMap(map['picture']),
      nat: map['nat'] as String,
      login: LoginModel.fromMap(map['login']),
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'name': name.toMap(),
      'email': email,
      'login': login.toMap(),
      'dob': dob.toMap(),
      'registered': registered.toMap(),
      'phone': phone,
      'cell': cell,
      'id': id.toMap(),
      'picture': picture.toMap(),
      'nat': nat,
    };
  }

  static Map<String, dynamic> toDatabase(UserModel u) {
    return {
      'uuid': u.login.uuid,
      'gender': u.gender,
      'email': u.email,
      'phone': u.phone,
      'cell': u.cell,
      'nat': u.nat,
      'name_title': u.name.title,
      'name_first': u.name.first,
      'name_last': u.name.last,
      'loc_street_number': u.location.street.number,
      'loc_street_name': u.location.street.name,
      'loc_city': u.location.city,
      'loc_state': u.location.state,
      'loc_country': u.location.country,
      'loc_postcode': u.location.postcode?.toString(),
      'loc_coords_lat': u.location.coordinates.lat,
      'loc_coords_lng': u.location.coordinates.long,
      'loc_tz_offset': u.location.timezone.offset,
      'loc_tz_desc': u.location.timezone.description,
      'login_username': u.login.username,
      'login_md5': u.login.md5,
      'login_sha1': u.login.sha1,
      'login_sha256': u.login.sha256,
      'dob_date': u.dob.date,
      'dob_age': u.dob.age,
      'reg_date': u.registered.date,
      'reg_age': u.registered.age,
      'id_name': u.id.name,
      'id_value': u.id.value,
      'picture_large': u.picture.large,
      'picture_medium': u.picture.medium,
      'picture_thumbnail': u.picture.thumbnail,
    };
  }

  factory UserModel.fromDatabase(Map<String, dynamic> m) {
    return UserModel(
      gender: m['gender'] as String,
      email: m['email'] as String,
      phone: (m['phone'] ?? '') as String,
      cell: (m['cell'] ?? '') as String,
      nat: (m['nat'] ?? '') as String,
      name: NameModel(
        title: (m['name_title'] ?? '') as String,
        first: (m['name_first'] ?? '') as String,
        last: (m['name_last'] ?? '') as String,
      ),
      location: LocationModel(
        street: StreetModel(
          number: (m['loc_street_number'] as int?) ?? 0,
          name: (m['loc_street_name'] ?? '') as String,
        ),
        city: (m['loc_city'] ?? '') as String,
        state: (m['loc_state'] ?? '') as String,
        country: (m['loc_country'] ?? '') as String,
        postcode: m['loc_postcode'],
        coordinates: CoordinatesModel(
          lat: (m['loc_coords_lat'] ?? '') as String,
          long: (m['loc_coords_lng'] ?? '') as String,
        ),
        timezone: TimezoneModel(
          offset: (m['loc_tz_offset'] ?? '') as String,
          description: (m['loc_tz_desc'] ?? '') as String,
        ),
      ),
      login: LoginModel(
        uuid: m['uuid'] as String,
        username: (m['login_username'] ?? '') as String,
        md5: (m['login_md5'] ?? '') as String,
        sha1: (m['login_sha1'] ?? '') as String,
        sha256: (m['login_sha256'] ?? '') as String,
      ),
      dob: DobModel(
        date: (m['dob_date'] ?? '') as String,
        age: (m['dob_age'] as int?) ?? 0,
      ),
      registered: RegisteredModel(
        date: (m['reg_date'] ?? '') as String,
        age: (m['reg_age'] as int?) ?? 0,
      ),
      id: IdModel(
        name: (m['id_name'] ?? '') as String,
        value: (m['id_value'] ?? '') as String,
      ),
      picture: PictureModel(
        large: (m['picture_large'] ?? '') as String,
        medium: (m['picture_medium'] ?? '') as String,
        thumbnail: (m['picture_thumbnail'] ?? '') as String,
      ),
    );
  }
}
