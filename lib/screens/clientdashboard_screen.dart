import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({Key? key}) : super(key: key);

  @override
  _ClientDashboardScreenState createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _upcomingMeetings = [
    {
      'lawyer': 'Dr. Emily Chen',
      'specialty': 'Immigration Law',
      'time': 'Today, 2:30 PM',
      'type': 'Video Consultation',
      'color': const Color(0xFF2E5BFF),
      'icon': Icons.videocam_rounded,
    },
    {
      'lawyer': 'Atty. James Wilson',
      'specialty': 'Corporate Law',
      'time': 'Tomorrow, 10:00 AM',
      'type': 'In-Person Meeting',
      'color': const Color(0xFF8C54FF),
      'icon': Icons.person_rounded,
    },
  ];

  final List<Map<String, dynamic>> _recentDocuments = [
    {
      'name': 'Visa Application Draft',
      'date': '2 days ago',
      'icon': Icons.description_rounded,
      'color': const Color(0xFF00C4FF),
    },
    {
      'name': 'Contract Review',
      'date': '1 week ago',
      'icon': Icons.assignment_rounded,
      'color': const Color(0xFF4CAF50),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Legal Dashboard'),
        actions: [
          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildWelcomeCard(),
              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Upcoming Meetings
              _buildSectionHeader('Upcoming Consultations', Iconsax.calendar),
              const SizedBox(height: 12),
              _buildMeetingsList(),
              const SizedBox(height: 24),

              // Recent Documents
              _buildSectionHeader('Recent Documents', Iconsax.document),
              const SizedBox(height: 12),
              _buildDocumentsList(),
              const SizedBox(height: 24),

              // Find Lawyers CTA
              _buildFindLawyerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2E5BFF).withOpacity(0.8),
            const Color(0xFF8C54FF).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sarah Johnson!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your legal matters are in good hands',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Iconsax.profile_circle,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _DashboardActionCard(
            icon: Iconsax.calendar_add,
            label: 'Book Consultation',
            color: const Color(0xFF2E5BFF),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DashboardActionCard(
            icon: Iconsax.document_upload,
            label: 'Upload Docs',
            color: const Color(0xFF8C54FF),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DashboardActionCard(
            icon: Iconsax.wallet,
            label: 'Payments',
            color: const Color(0xFF4CAF50),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blueGrey.shade800),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingsList() {
    return Column(
      children: [
        ..._upcomingMeetings.map(
          (meeting) => _MeetingCard(
            lawyer: meeting['lawyer'],
            specialty: meeting['specialty'],
            time: meeting['time'],
            type: meeting['type'],
            color: meeting['color'],
            icon: meeting['icon'],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: const Text('View All Appointments'),
        ),
      ],
    );
  }

  Widget _buildDocumentsList() {
    return Column(
      children: [
        ..._recentDocuments.map(
          (doc) => _DocumentCard(
            name: doc['name'],
            date: doc['date'],
            icon: doc['icon'],
            color: doc['color'],
          ),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('View All Documents')),
      ],
    );
  }

  Widget _buildFindLawyerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5BFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.search_favorite,
              size: 28,
              color: Color(0xFF2E5BFF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need another specialist?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find the perfect lawyer for your case',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (index) => setState(() => _selectedTab = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2E5BFF),
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.calendar),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.document_text),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.profile_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DashboardActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final String lawyer;
  final String specialty;
  final String time;
  final String type;
  final Color color;
  final IconData icon;

  const _MeetingCard({
    required this.lawyer,
    required this.specialty,
    required this.time,
    required this.type,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lawyer,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String name;
  final String date;
  final IconData icon;
  final Color color;

  const _DocumentCard({
    required this.name,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download_rounded, color: Colors.blueGrey.shade600),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
