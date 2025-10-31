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

  factory UserModel.fromDatabase(Map<String, dynamic> json) {
    return UserModel(
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      cell: json['cell'] as String,
      nat: json['nat'] as String,
      name: NameModel(
        title: json['name_title'] as String,
        first: json['name_first'] as String,
        last: json['name_last'] as String,
      ),
      location: LocationModel(
        street: StreetModel(
          number: json['loc_street_number'] ?? 0,
          name: json['loc_street_name'] as String,
        ),
        city: json['loc_city'] as String,
        state: json['loc_state'] as String,
        country: json['loc_country'] as String,
        postcode: json['loc_postcode'] as dynamic,
        coordinates: CoordinatesModel(
          lat: json['loc_coords_lat'] as String,
          long: json['loc_coords_lng'] as String,
        ),
        timezone: TimezoneModel(
          offset: json['loc_tz_offset'] as String,
          description: json['loc_tz_desc'] as String,
        ),
      ),
      login: LoginModel(
        uuid: json['uuid'] as String,
        username: json['login_username'] as String,
        md5: json['login_md5'] as String,
        sha1: json['login_sha1'] as String,
        sha256: json['login_sha256'] as String,
      ),
      dob: DobModel(
        date: json['dob_date'] as String,
        age: json['dob_age'] as int,
      ),
      registered: RegisteredModel(
        date: json['reg_date'] as String,
        age: json['reg_age'] as int,
      ),
      id: IdModel(
        name: json['id_name'] as String,
        value: json['id_value'] as String?,
      ),
      picture: PictureModel(
        large: json['picture_large'] as String,
        medium: json['picture_medium'] as String,
        thumbnail: json['picture_thumbnail'] as String,
      ),
    );
  }
}
