import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GuestBrowseScreen extends StatefulWidget {
  const GuestBrowseScreen({Key? key}) : super(key: key);

  @override
  _GuestBrowseScreenState createState() => _GuestBrowseScreenState();
}

class _GuestBrowseScreenState extends State<GuestBrowseScreen> {
  final List<String> _specialties = [
    'All',
    'Tax Law',
    'Immigration',
    'Corporate',
    'Family Law',
    'Criminal',
    'Property',
    'Employment',
  ];

  String _selectedSpecialty = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Lawyer> _lawyers = [
    Lawyer(
      name: 'Sarah Johnson',
      specialty: 'Family Law',
      rating: 4.8,
      reviews: 124,
      experience: 12,
      image: 'assets/lawyer1.jpg',
    ),
    Lawyer(
      name: 'Michael Chen',
      specialty: 'Corporate Law',
      rating: 4.9,
      reviews: 89,
      experience: 15,
      image: 'assets/lawyer2.jpg',
    ),
    Lawyer(
      name: 'David Rodriguez',
      specialty: 'Immigration',
      rating: 4.7,
      reviews: 156,
      experience: 10,
      image: 'assets/lawyer3.jpg',
    ),
    Lawyer(
      name: 'Emily Wilson',
      specialty: 'Tax Law',
      rating: 4.6,
      reviews: 72,
      experience: 8,
      image: 'assets/lawyer4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Browse Lawyers'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGuestInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search lawyers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Specialty filter chips
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _specialties.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final specialty = _specialties[index];
                      return ChoiceChip(
                        label: Text(specialty),
                        selected: _selectedSpecialty == specialty,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (selected) {
                          setState(() {
                            _selectedSpecialty = selected ? specialty : 'All';
                          });
                        },
                        labelStyle: TextStyle(
                          color:
                              _selectedSpecialty == specialty
                                  ? Colors.blue.shade800
                                  : Colors.grey.shade800,
                          fontWeight:
                              _selectedSpecialty == specialty
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                _selectedSpecialty == specialty
                                    ? Colors.blue.shade300
                                    : Colors.grey.shade300,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Lawyers list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredLawyers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final lawyer = _filteredLawyers[index];
                return _buildLawyerCard(lawyer);
              },
            ),
          ),
        ],
      ),

      // Sign up prompt
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Sign up to contact lawyers',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                // Navigate to sign up screen
                Navigator.pushNamed(context, '/client-onboarding');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  List<Lawyer> get _filteredLawyers {
    return _lawyers.where((lawyer) {
      final matchesSearch =
          lawyer.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          lawyer.specialty.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesSpecialty =
          _selectedSpecialty == 'All' || lawyer.specialty == _selectedSpecialty;

      return matchesSearch && matchesSpecialty;
    }).toList();
  }

  Widget _buildLawyerCard(Lawyer lawyer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showLawyerDetails(context, lawyer);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lawyer photo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(lawyer.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Lawyer details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lawyer.specialty,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),

                    // Rating and experience
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: lawyer.rating,
                          itemBuilder:
                              (context, index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 16,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${lawyer.rating} (${lawyer.reviews})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lawyer.experience} years experience',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // View button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  _showLawyerDetails(context, lawyer);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLawyerDetails(BuildContext context, Lawyer lawyer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Lawyer header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(lawyer.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lawyer.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lawyer.specialty,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: lawyer.rating,
                          itemBuilder:
                              (context, index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 16,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Details
              _buildDetailRow(
                Icons.work_outline,
                '${lawyer.experience} years experience',
              ),
              _buildDetailRow(
                Icons.star_border,
                '${lawyer.rating} rating (${lawyer.reviews} reviews)',
              ),
              _buildDetailRow(Icons.location_on_outlined, 'New York, NY'),
              const SizedBox(height: 20),

              // About section
              const Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Specialized in all aspects of family law including divorce, child custody, and prenuptial agreements. Committed to providing personalized legal solutions.',
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Sign up prompt
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sign up to contact ${lawyer.name.split(' ')[0]}',
                        style: TextStyle(color: Colors.blue.shade800),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to sign up
                        Navigator.pushNamed(context, '/client-onboarding');
                      },
                      child: const Text('SIGN UP'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  void _showGuestInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Guest Browsing'),
          content: const Text(
            'As a guest, you can browse lawyer profiles but need to sign up to contact them or access full features.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('GOT IT'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to sign up
              },
              child: const Text('SIGN UP'),
            ),
          ],
        );
      },
    );
  }
}

class Lawyer {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final int experience;
  final String image;

  Lawyer({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.image,
  });
}
