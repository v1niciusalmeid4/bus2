class PictureModel {
  final String large;
  final String medium;
  final String thumbnail;

  PictureModel({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });

  factory PictureModel.fromMap(dynamic map) {
    return PictureModel(
      large: map['large'] as String,
      medium: map['medium'] as String,
      thumbnail: map['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'large': large,
      'medium': medium,
      'thumbnail': thumbnail,
    };
  }
}
