class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? avatarUrl;

  User({required this.id, required this.firstName, required this.lastName, this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String? ?? json['firstName'] as String? ?? '',
      lastName: json['last_name'] as String? ?? json['lastName'] as String? ?? '',
      avatarUrl: json['avatar'] as String?
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'avatar': avatarUrl,
  };

  String get fullName => '$firstName $lastName';
}
