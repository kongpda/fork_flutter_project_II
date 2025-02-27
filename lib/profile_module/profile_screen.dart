import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/api_module/event_model.dart';
import 'package:flutter_project_ii/detail_screen.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:flutter_project_ii/profile_module/information_screen.dart';
import 'package:flutter_project_ii/profile_module/language_screen.dart';
import 'package:flutter_project_ii/slide_model.dart';
import 'package:flutter_project_ii/tickets/ticket_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';

enum ChangeWidget {
  grid,
  tickets,
  setting,
}

class ProfileScreen extends StatefulWidget {
 // const ProfileScreen({super.key});
 

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ChangeWidget selectedWidget = ChangeWidget.grid;
  List<Event> eventsByOrganizer = [];
  bool isSelected = false;
  final int _langIndex = 0;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1A202C),
        child: Column(
          children: [
            SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/2080383/pexels-photo-2080383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  "Adam John Levine",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Levineadam@mail.com",
                  style: TextStyle(color: Colors.grey.shade400),
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
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 40,
        bottom: 40,
      ),
      children: [
        Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Icon(
                  Icons.notifications_none,
                  color: Color(0xFF455AF7),
                )),
            SizedBox(
              width: 30,
            ),
            Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_sharp,
              color: Colors.grey.shade500,
              size: 34,
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            // Navigate to change password screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalInformationScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    Icons.person_outline_outlined,
                    color: Color(0xFF455AF7),
                  )),
              SizedBox(
                width: 30,
              ),
              Text(
                "Personal Information",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              Icon(
                Icons.navigate_next_sharp,
                color: Colors.grey.shade500,
                size: 34,
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            // Navigate to change password screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeLanguageScreen(),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    Icons.translate,
                    color: Color(0xFF455AF7),
                  )),
              SizedBox(
                width: 30,
              ),
              Text(
                "Language",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              Text(
                langIndex == 1 ? "Khmer" : "English",
                style: TextStyle(color: Colors.grey.shade500),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.navigate_next_sharp,
                color: Colors.grey.shade500,
                size: 34,
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Icon(
                  Icons.settings,
                  color: Color(0xFF455AF7),
                )),
            SizedBox(
              width: 30,
            ),
            Text(
              "Setting",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_sharp,
              color: Colors.grey.shade500,
              size: 34,
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () async {
            await context.read<AuthProvider>().logout();
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            }
          },
          child: Row(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Color(0xFF455AF7),
                  )),
              SizedBox(width: 30),
              Text(
                "Logout",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              Icon(
                Icons.navigate_next_sharp,
                color: Colors.grey.shade500,
                size: 34,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem() {
    List<Event> eventsByOrganizer = context.watch<EventLogic>().eventsByOrganizer;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
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
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailScreen(post),)
        );
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
