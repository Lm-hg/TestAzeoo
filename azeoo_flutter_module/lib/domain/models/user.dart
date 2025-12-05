class UserPicture {
  final String url;
  final String label;

  UserPicture({required this.url, required this.label});

  factory UserPicture.fromJson(Map<String, dynamic> json) {
    return UserPicture(
      url: json['url'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

class UserBadge {
  final int id;
  final String name;
  final String description;

  UserBadge({required this.id, required this.name, required this.description});

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String info;
  final String email;
  final List<UserPicture> pictures;
  final String accountType;
  final String countryFlag;
  final int points;
  final int badgesCount;
  final List<UserBadge> badges;
  final String city;
  final String countryCode;
  final int followersCount;
  final int workoutsCount;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.info,
    required this.email,
    required this.pictures,
    required this.accountType,
    required this.countryFlag,
    required this.points,
    required this.badgesCount,
    required this.badges,
    required this.city,
    required this.countryCode,
    required this.followersCount,
    required this.workoutsCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final picturesList = (json['picture'] as List<dynamic>?)?.map((e) => UserPicture.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String? ?? json['firstName'] as String? ?? '',
      lastName: json['last_name'] as String? ?? json['lastName'] as String? ?? '',
      avatarUrl: json['avatar'] as String?,
      info: json['info'] as String? ?? '',
      email: json['email'] as String? ?? '',
      pictures: picturesList,
      accountType: json['account_type'] as String? ?? 'free',
      countryFlag: json['country_flag'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      badgesCount: json['badges_count'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.take(3).map((e) => UserBadge.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      city: (json['city'] as Map<String, dynamic>?)?['value'] as String? ?? '',
      countryCode: json['country_code'] as String? ?? '',
      followersCount: json['followers_count'] as int? ?? 0,
      workoutsCount: json['workouts_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'avatar': avatarUrl,
    'info': info,
    'email': email,
    'account_type': accountType,
    'points': points,
  };

  String get fullName => '$firstName $lastName';
  String? get profilePicture {
    if (pictures.isEmpty) return avatarUrl;
    try {
      return pictures.firstWhere((p) => p.label == 'large').url;
    } catch (_) {
      return pictures.first.url;
    }
  }
}
