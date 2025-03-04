class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? birthDate;
  final String? phone;
  final String? avatarUrl;
  final String? status;
  final String? bio;
  final String? address;
  final Map<String, dynamic>? socialLinks;
  final String? createdAt;
  final String? updatedAt;
  final String? relationshipsProfileId;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.birthDate,
    this.phone,
    this.avatarUrl,
    this.status,
    this.bio,
    this.address,
    this.socialLinks,
    this.createdAt,
    this.updatedAt,
    this.relationshipsProfileId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print('Starting UserProfile.fromJson with data: $json');

    // Extract user data from the nested structure
    final userData = json['user'] ?? json;
    print('Extracted userData: $userData');

    // Get user attributes
    final attributes = userData['attributes'] ?? {};
    print('Extracted attributes: $attributes');

    // Get profile data from relationships
    Map<String, dynamic> profileData = {};
    String? relationshipsProfileId;

    // Based on the log structure, explicitly look for the numeric profile ID
    try {
      // From logs: user.relationships.profile.id (21)
      if (userData['relationships'] != null &&
          userData['relationships']['profile'] != null) {
        final profile = userData['relationships']['profile'];
        print('Found profile in relationships: $profile');

        // Extract the profile ID
        if (profile['id'] != null) {
          // Direct ID in profile
          relationshipsProfileId = profile['id'].toString();
          print('Found profile ID (direct): $relationshipsProfileId');
        } else if (profile['type'] == 'profiles' && profile['id'] != null) {
          relationshipsProfileId = profile['id'].toString();
          print('Found profile ID (with type): $relationshipsProfileId');
        }

        // Extract from the attributes within relationships
        if (profile['attributes'] != null) {
          profileData = profile['attributes'];
          print('Extracted profile attributes: $profileData');
        }

        // Try getting from the API structure specifically seen in logs
        // Log shows: "profile: {type: profiles, id: 21, attributes:..."
        print('Relationships profile structure: $profile');

        // Directly extract ID from the observed structure
        if (profile is Map && profile.containsKey('id')) {
          relationshipsProfileId = profile['id'].toString();
          print('Found profile ID from map: $relationshipsProfileId');
        }
      }
    } catch (e) {
      print('Error extracting profile data: $e');
    }

    // If the response has data.attributes structure (direct profile response)
    if (json['data'] != null && json['data']['attributes'] != null) {
      profileData = json['data']['attributes'];

      // If we have a direct profile response, use its ID
      if (json['data']['id'] != null) {
        userData['profile_id'] = json['data']['id'];
        relationshipsProfileId = json['data']['id'].toString();
      }
    }

    print('Final extracted relationshipsProfileId: $relationshipsProfileId');
    print('Final profileData: $profileData');
    print('Full userData structure for debugging: $userData');

    // Make sure we have a valid ID
    String id = '';
    if (userData['profile_id'] != null) {
      id = userData['profile_id'].toString();
    } else if (userData['id'] != null) {
      id = userData['id'].toString();
    } else if (relationshipsProfileId != null) {
      id = relationshipsProfileId;
    }
    print('Final ID to be used: $id');

    // Make sure we have valid name and email
    String name = attributes['name'] ?? '';
    String email = attributes['email'] ?? '';

    print('Final name to be used: $name');
    print('Final email to be used: $email');

    return UserProfile(
      id: id,
      name: name,
      email: email,
      firstName: profileData['first_name'],
      lastName: profileData['last_name'],
      fullName: profileData['full_name'],
      birthDate: profileData['birth_date'],
      phone: profileData['phone'],
      avatarUrl: profileData['avatar'],
      status: profileData['status'],
      bio: profileData['bio'],
      address: profileData['address'],
      socialLinks: profileData['social_links'] != null
          ? (profileData['social_links'] is Map
              ? Map<String, dynamic>.from(profileData['social_links'])
              : {'links': profileData['social_links']})
          : null,
      createdAt: attributes['created_at'],
      updatedAt: attributes['updated_at'],
      relationshipsProfileId: relationshipsProfileId,
    );
  }

  // Helper method to get display name
  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!;
    } else if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (name.isNotEmpty) {
      return name;
    } else {
      return 'User';
    }
  }

  // Get username directly
  String get username => name;
}
