import 'package:flutter/material.dart';
import 'package:flutter_project_ii/tickets/ticket_detail_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A202C),
        title: Text('My Ticket', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          // Custom Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(4),
            height: 45, // Fixed height for better control
            decoration: BoxDecoration(
              color: Color(0xFF1E2630),
              borderRadius: BorderRadius.circular(25),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[800]!,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Color(0xFF007AFF), // iOS blue color
                borderRadius: BorderRadius.circular(25),
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF8E8E93), // iOS gray color
              tabs: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Tab(text: 'Upcoming'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Tab(text: 'Past ticket'),
                ),
              ],
            ),
          ),

          SizedBox(height: 16), // Add spacing here

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Tickets
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildTicketCard(
                      'Disco Tehran - Goodbye Party',
                      '23 Oct - 08:00 PM',
                      'Regular ticket : 1',
                      context,
                    ),
                    SizedBox(height: 16),
                    _buildTicketCard(
                      'Everyday People NYC: rOLLER',
                      '31 Oct - 08:00 PM',
                      'Regular ticket : 1',
                      context,
                    ),
                  ],
                ),
                // Past Tickets
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
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
                ),
              ],
            ),
          ),
        ],
      ),
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
}

// Custom painter for dotted line
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
