import 'dart:convert';

class User {
  String? asdasdddsa;
  String? asdqwe;
  String? asdwqeqw;

  User({this.asdasdddsa, this.asdqwe, this.asdwqeqw});

  @override
  String toString() {
    return 'User(asdasdddsa: $asdasdddsa, asdqwe: $asdqwe, asdwqeqw: $asdwqeqw)';
  }

  factory User.fromMap(Map<String, dynamic> data) => User(
        asdasdddsa: data['asdasdddsa'] as String?,
        asdqwe: data['asdqwe'] as String?,
        asdwqeqw: data['asdwqeqw'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'asdasdddsa': asdasdddsa,
        'asdqwe': asdqwe,
        'asdwqeqw': asdwqeqw,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    String? asdasdddsa,
    String? asdqwe,
    String? asdwqeqw,
  }) {
    return User(
      asdasdddsa: asdasdddsa ?? this.asdasdddsa,
      asdqwe: asdqwe ?? this.asdqwe,
      asdwqeqw: asdwqeqw ?? this.asdwqeqw,
    );
  }
}
