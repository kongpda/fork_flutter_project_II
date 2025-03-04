import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/models/user_profile.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile =
          Provider.of<AuthProvider>(context, listen: false).userProfile;
      if (userProfile != null) {
        _emailController.text = userProfile.email;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
        title: Text('Security Settings', style: TextStyle(color: Colors.white)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  "Account Security",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Manage your email and password to keep your account secure",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
                _buildEmailInput(),
                SizedBox(height: 30),
                Text(
                  "Change Password",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter your current password and a new password to update it",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                _buildCurrentPasswordInput(),
                SizedBox(height: 20),
                _buildNewPasswordInput(),
                SizedBox(height: 20),
                _buildConfirmPasswordInput(),
                SizedBox(height: 40),
                _buildSaveButton(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 15),
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enabled: false, // Email is usually not editable
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildCurrentPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Password",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 15),
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
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                      ),
                      hintText: 'Enter current password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ))),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _hidePassword,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildNewPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New Password",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 15),
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
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                      ),
                      hintText: 'Enter new password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hideNewPassword = !_hideNewPassword;
                            });
                          },
                          icon: Icon(
                            _hideNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ))),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _hideNewPassword,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildConfirmPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm New Password",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 15),
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
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                      ),
                      hintText: 'Confirm new password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ))),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  obscureText: _hideConfirmPassword,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Validate passwords match
          if (_newPasswordController.text.isNotEmpty &&
              _newPasswordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New passwords do not match'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          try {
            // Get the auth provider
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            // TODO: Implement password change functionality
            // This would typically call a method like:
            // final result = await authProvider.changePassword(
            //   currentPassword: _passwordController.text,
            //   newPassword: _newPasswordController.text,
            // );

            // For now, just simulate success
            await Future.delayed(Duration(seconds: 1));
            final result = {
              'success': true,
              'message': 'Password updated successfully'
            };

            // Close loading indicator
            if (context.mounted) Navigator.pop(context);

            // Show result message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message'] as String),
                  backgroundColor:
                      result['success'] == true ? Colors.green : Colors.red,
                ),
              );

              if (result['success'] == true) {
                // Clear password fields
                _passwordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              }
            }
          } catch (e) {
            // Close loading indicator
            if (context.mounted) Navigator.pop(context);

            // Show error message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('An error occurred while updating your password'),
                  backgroundColor: Colors.red,
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
        child: const Text('Update Password',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }
}
