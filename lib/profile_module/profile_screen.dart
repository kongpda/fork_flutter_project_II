import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:flutter_project_ii/profile_module/information_screen.dart';
import 'package:flutter_project_ii/profile_module/language_screen.dart';
import 'package:flutter_project_ii/profile_module/security_settings_screen.dart';
import 'package:flutter_project_ii/tickets/ticket_detail_screen.dart';
import 'package:flutter_project_ii/user_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/models/user_profile.dart';

enum ChangeWidget {
  grid,
  tickets,
  setting,
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ChangeWidget selectedWidget = ChangeWidget.grid;
  List<Event> eventsByOrganizer = [];
  bool isSelected = false;
  final int _langIndex = 0;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();

    // Refresh user profile when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshUserData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // This method will be called when this screen is shown
  void refreshOnTabSelected() {
    print('Profile tab selected, refreshing data');
    if (mounted) {
      _refreshUserData();
    }
  }

  void _refreshUserData() {
    print('Refreshing user profile data');
    Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
    Provider.of<EventLogic>(context, listen: false).readByOrganizer(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final UserProfile? userProfile = authProvider.userProfile;

    // Check if this is the first build and userProfile is null
    if (_isFirstLoad && userProfile == null) {
      _isFirstLoad = false;
      // Schedule a refresh after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshUserData();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A202C),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              final result = await authProvider.fetchUserProfile();
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show debug info
              if (userProfile != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('User Profile Debug Info'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('ID: ${userProfile.id}'),
                          Text('Name: ${userProfile.name}'),
                          Text('Email: ${userProfile.email}'),
                          Text('Display Name: ${userProfile.displayName}'),
                          Text('First Name: ${userProfile.firstName ?? "N/A"}'),
                          Text('Last Name: ${userProfile.lastName ?? "N/A"}'),
                          Text('Full Name: ${userProfile.fullName ?? "N/A"}'),
                          Text('Avatar URL: ${userProfile.avatarUrl ?? "N/A"}'),
                          Text('Phone: ${userProfile.phone ?? "N/A"}'),
                          Text('Status: ${userProfile.status ?? "N/A"}'),
                          Text('Bio: ${userProfile.bio ?? "N/A"}'),
                          Text('Address: ${userProfile.address ?? "N/A"}'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No profile data available')),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF1A202C),
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: userProfile?.avatarUrl != null &&
                        userProfile!.avatarUrl!.isNotEmpty
                    ? NetworkImage(userProfile.avatarUrl!)
                    : NetworkImage(
                        "https://images.pexels.com/photos/2080383/pexels-photo-2080383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                if (userProfile?.name != userProfile?.displayName &&
                    userProfile?.name.isNotEmpty == true)
                  Text(
                    "@${userProfile!.name}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    decoration: selectedWidget == ChangeWidget.grid
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          )
                        : null,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedWidget = ChangeWidget.grid;
                        });
                      },
                      icon: Icon(
                        Icons.grid_on,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    decoration: selectedWidget == ChangeWidget.tickets
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          )
                        : null,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedWidget = ChangeWidget.tickets;
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.ticket,
                          size: 35,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    decoration: selectedWidget == ChangeWidget.setting
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          )
                        : null,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedWidget = ChangeWidget.setting;
                          });
                        },
                        icon: Icon(
                          Icons.settings_applications_outlined,
                          size: 35,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: _buildChangeBodyProfile(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeBodyProfile() {
    switch (selectedWidget) {
      case ChangeWidget.grid:
        return _buildGridItem();
      case ChangeWidget.tickets:
        return _buildTicketsItem();
      case ChangeWidget.setting:
        return _buildSettingItem();
    }
  }

  Widget _buildTicketsItem() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(
          height: 20,
        ),
        _buildTicketCard(
          'Summer Music Festival',
          '15 Aug - 07:00 PM',
          'Regular ticket : 1',
          context,
        ),
        SizedBox(height: 16),
        _buildTicketCard(
          'Jazz Night Special',
          '10 Sep - 09:00 PM',
          'Regular ticket : 1',
          context,
        ),
      ],
    );
  }

  Widget _buildTicketCard(
      String title, String date, String ticketInfo, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailScreen(
              title: title,
              date: date,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1A1D24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side of the ticket
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    ticketInfo,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Dotted line separator
            SizedBox(
              height: 80,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomPaint(
                  painter: DottedLinePainter(),
                  size: Size(1, double.infinity),
                ),
              ),
            ),
            // QR Code section
            Container(
              padding: EdgeInsets.all(8), // White border padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/images/google-qr.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem() {
    int langIndex = context.watch<LanguageLogic>().langIndex;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      children: [
        // Notifications row
        _buildSettingsRow(
          icon: Icons.notifications_outlined,
          title: "Notifications",
          onTap: () {
            // Navigate to notifications screen when implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notifications feature coming soon')),
            );
          },
        ),

        // Personal Information row
        _buildSettingsRow(
          icon: Icons.person_outline_rounded,
          title: "Personal Information",
          onTap: () {
            // Navigate directly to personal information screen without expecting a refresh on return
            print('Navigating to PersonalInformationScreen');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalInformationScreen(),
              ),
            ).then((_) {
              // Instead of expecting the previous screen to handle refresh, we explicitly refresh here
              print(
                  'Returned from PersonalInformationScreen, refreshing profile data');
              if (mounted) {
                setState(() {
                  // Just trigger a rebuild to reflect any changes
                });
                // Refresh user profile data without showing a loading indicator
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .fetchUserProfile();
                });
              }
            });
          },
        ),

        // Language row
        _buildSettingsRow(
          icon: Icons.translate,
          title: "Language",
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                langIndex == 1 ? "Khmer" : "English",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.navigate_next_sharp,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
          onTap: () {
            // Navigate to change language screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeLanguageScreen(),
              ),
            );
          },
        ),

        // Settings row
        _buildSettingsRow(
          icon: Icons.settings_outlined,
          title: "Settings",
          onTap: () {
            // Navigate to settings screen when implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Settings feature coming soon')),
            );
          },
        ),

        // Security row
        _buildSettingsRow(
          icon: Icons.security,
          title: "Security",
          onTap: () {
            // Navigate to security settings screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SecuritySettingsScreen(),
              ),
            );
          },
        ),

        // Logout row
        _buildSettingsRow(
          icon: Icons.logout_outlined,
          title: "Logout",
          onTap: () async {
            await context.read<AuthProvider>().logout();
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  // Helper method to build consistent settings rows
  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Color(0xFF455AF7).withOpacity(0.1),
        highlightColor: Color(0xFF1A1D24).withOpacity(0.3),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF151921),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFF455AF7),
                  size: 20,
                ),
              ),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              trailing ??
                  Icon(
                    Icons.navigate_next_sharp,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem() {
    final eventLogic = context.watch<EventLogic>();
    final List<Event> eventsByOrganizer = eventLogic.eventsByOrganizer;
    final bool isLoading = eventLogic.isLoading;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (eventsByOrganizer.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade600,
            ),
            SizedBox(height: 16),
            Text(
              "No events found",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                eventLogic.readByOrganizer(context);
              },
              icon: Icon(Icons.refresh),
              label: Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF455AF7),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  eventLogic.readByOrganizer(context);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: eventsByOrganizer.length,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              return _buildPostItem(eventsByOrganizer[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(Event post) {
    return _navigateToDetailScreen(
      post,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.attributes.featureImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _navigateToDetailScreen(Event post, {Widget? child}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserDetailScreen(post),
        ));
      },
      child: child,
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const double dashHeight = 4;
    const double dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
