import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/models/user_profile.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  File? _selectedImage;
  bool _isUploadingImage = false;
  bool _isRemovingImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile =
          Provider.of<AuthProvider>(context, listen: false).userProfile;
      if (userProfile != null) {
        _fullNameController.text = userProfile.displayName;
        if (userProfile.phone != null) {
          _phoneController.text = userProfile.phone!;
        }
        if (userProfile.bio != null) {
          _bioController.text = userProfile.bio!;
        }
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final UserProfile? userProfile = authProvider.userProfile;

    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text('Personal Information', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Color(0xFF1A202C),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getProfileImage(userProfile),
                        child: _shouldShowPlaceholder(userProfile)
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey.shade400,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: (_isUploadingImage || _isRemovingImage)
                            ? null
                            : _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF455AF7),
                            shape: BoxShape.circle,
                          ),
                          child: (_isUploadingImage || _isRemovingImage)
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      userProfile?.displayName ?? "Guest User",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      userProfile?.email ?? "guest@example.com",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    _buildFullNameInput(),
                    SizedBox(height: 30),
                    _buildPhoneInput(),
                    SizedBox(height: 30),
                    _buildBioInput(),
                    SizedBox(height: 30),
                    if (userProfile?.address != null) ...[
                      _buildAddressInfo(userProfile!.address!),
                      SizedBox(height: 30),
                    ],
                    __buildSaveButton(),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Full Name",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            padding: EdgeInsets.only(left: 20),
            height: 70,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person_outline_sharp,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            padding: EdgeInsets.only(left: 20),
            height: 70,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildBioInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bio",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            padding: EdgeInsets.only(left: 20),
            height: 120,
            width: double.maxFinite,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                    ),
                    hintText: 'Tell us about yourself',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  autocorrect: false,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildAddressInfo(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontSize: 18, color: Colors.white)),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(15),
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade800),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            address,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget __buildSaveButton() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Show a loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) {
              return WillPopScope(
                onWillPop: () async => false,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );

          try {
            // Perform the API update in a separate method
            await _performProfileUpdate();

            // Close the loading dialog on success
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            // Show success message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }

            // Update the UI
            if (mounted) {
              setState(() {
                // Update controllers with new data
                final updatedProfile =
                    Provider.of<AuthProvider>(context, listen: false)
                        .userProfile;
                if (updatedProfile != null) {
                  _fullNameController.text = updatedProfile.displayName;
                }
              });
            }
          } catch (e) {
            // Close the loading dialog on error
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            // Show error message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error updating profile: $e'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0466C8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Save Changes',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  // This is a completely separate method that handles the actual API update
  Future<void> _performProfileUpdate() async {
    if (!mounted) return;

    print('Starting profile update process');
    print('Full name from controller: ${_fullNameController.text}');

    // Get the auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfile = authProvider.userProfile;

    print('Current profile data:');
    print('- ID: ${userProfile?.id}');
    print('- Name: ${userProfile?.name}');
    print('- Email: ${userProfile?.email}');
    print('- First Name: ${userProfile?.firstName}');
    print('- Last Name: ${userProfile?.lastName}');
    print('- Full Name: ${userProfile?.fullName}');
    print('- Display Name: ${userProfile?.displayName}');
    print('- Relationships Profile ID: ${userProfile?.relationshipsProfileId}');

    // Split full name into first and last name
    final nameParts = _fullNameController.text.trim().split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    print('Parsed name parts:');
    print('- First Name: $firstName');
    print('- Last Name: $lastName');
    print('- Phone: ${_phoneController.text}');
    print('- Bio: ${_bioController.text}');

    // Update the profile
    final result = await authProvider.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      bio: _bioController.text.isNotEmpty ? _bioController.text : null,
    );

    print('Profile update result: $result');

    if (result['success']) {
      print('Update successful, refreshing profile data');
      await authProvider.fetchUserProfile();

      // Log the updated profile data
      final updatedProfile = authProvider.userProfile;
      print('Updated profile data:');
      print('- ID: ${updatedProfile?.id}');
      print('- Name: ${updatedProfile?.name}');
      print('- Email: ${updatedProfile?.email}');
      print('- First Name: ${updatedProfile?.firstName}');
      print('- Last Name: ${updatedProfile?.lastName}');
      print('- Full Name: ${updatedProfile?.fullName}');
      print('- Display Name: ${updatedProfile?.displayName}');
      print(
          '- Relationships Profile ID: ${updatedProfile?.relationshipsProfileId}');
    } else {
      throw Exception(result['message'] ?? 'Failed to update profile');
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;

    final ImagePicker picker = ImagePicker();
    try {
      // Show bottom sheet with options
      showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xFF1A202C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Profile Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF455AF7).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, color: Color(0xFF455AF7)),
                    ),
                    title: Text('Take a photo',
                        style: TextStyle(color: Colors.white)),
                    onTap: () async {
                      Navigator.pop(context);
                      await _getImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF455AF7).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.photo_library, color: Color(0xFF455AF7)),
                    ),
                    title: Text('Choose from gallery',
                        style: TextStyle(color: Colors.white)),
                    onTap: () async {
                      Navigator.pop(context);
                      await _getImage(ImageSource.gallery);
                    },
                  ),
                  if (_hasExistingAvatar())
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                      title: Text('Remove current photo',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        _removeAvatar();
                      },
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    if (!mounted) return;

    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Upload the image
        await _uploadAvatar();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _uploadAvatar() async {
    if (_selectedImage == null || !mounted) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.uploadAvatar(_selectedImage!);

      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: result['success'] ? Colors.green : Colors.red,
            ),
          );
        } catch (e) {
          print('Error showing upload result snackbar: $e');
        }
      }
    } catch (e) {
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } catch (e) {
          print('Error showing upload error snackbar: $e');
        }
      }
    } finally {
      if (mounted) {
        try {
          setState(() {
            _isUploadingImage = false;
          });
        } catch (e) {
          print('Error updating upload state: $e');
        }
      }
    }
  }

  // Helper method to check if user has an existing avatar
  bool _hasExistingAvatar() {
    final userProfile =
        Provider.of<AuthProvider>(context, listen: false).userProfile;
    return userProfile?.avatarUrl != null && userProfile!.avatarUrl!.isNotEmpty;
  }

  // Method to remove the avatar
  Future<void> _removeAvatar() async {
    if (!mounted) return;

    setState(() {
      _isRemovingImage = true;
      _selectedImage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.removeAvatar();

      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: result['success'] ? Colors.green : Colors.red,
            ),
          );
        } catch (e) {
          print('Error showing remove result snackbar: $e');
        }
      }
    } catch (e) {
      if (mounted) {
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } catch (e) {
          print('Error showing remove error snackbar: $e');
        }
      }
    } finally {
      if (mounted) {
        try {
          setState(() {
            _isRemovingImage = false;
          });
        } catch (e) {
          print('Error updating remove state: $e');
        }
      }
    }
  }

  // Helper method to determine if placeholder should be shown
  bool _shouldShowPlaceholder(UserProfile? userProfile) {
    if (_selectedImage != null) return false;
    return userProfile?.avatarUrl == null || userProfile!.avatarUrl!.isEmpty;
  }

  // Helper method to get the appropriate image provider
  ImageProvider? _getProfileImage(UserProfile? userProfile) {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (userProfile?.avatarUrl != null &&
        userProfile!.avatarUrl!.isNotEmpty) {
      return NetworkImage(userProfile.avatarUrl!);
    }
    return null;
  }
}
