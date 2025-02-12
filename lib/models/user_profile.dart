class UserProfile {
  final String username;
  final String email;
  final String? avatarUrl;

  UserProfile({
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
    );
  }
}
