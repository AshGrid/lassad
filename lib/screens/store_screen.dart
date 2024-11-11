import 'package:flutter/material.dart';
import 'ResumeDetailsPage.dart';
import 'add_resume.dart';
import 'PaymentPage.dart';
import '../services/resume-service.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ResumeService resumeService = ResumeService();
  List<Map<String, dynamic>> unpaidCourses = [];
  List<Map<String, dynamic>> paidCourses = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    _fetchUnpaidCourses();
    _fetchPaidCourses();
  }

  void _fetchUnpaidCourses() async {
    List<Map<String, dynamic>> fetchedUnpaidCourses = await resumeService.getUnpaidCourses();
    setState(() {
      unpaidCourses = fetchedUnpaidCourses;
      print("Fetched unpaid courses: $unpaidCourses");  // Debugging
    });
  }

  void _fetchPaidCourses() async {
    List<Map<String, dynamic>> fetchedPaidCourses = await resumeService.fetchPaidCourses();
    setState(() {
      paidCourses = fetchedPaidCourses;
      print("Fetched paid courses: $paidCourses");  // Debugging
    });
  }


  void _addToCart(Map<String, dynamic> course) {
    setState(() {
      cart.add(course);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${course['title']} added to cart!')),
    );
  }

  void _addCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddResumeScreen()),
    );
  }

  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  String selectedReference = 'All';
  double selectedMaxPrice = 100.0;
  String selectedLevel = 'All';

  List<String> references = ['All', 'Math', 'Science', 'Physics', 'Chemistry', 'Biology'];
  List<String> levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search by Title',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    searchQuery = searchController.text;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedReference,
                  decoration: InputDecoration(labelText: 'Courses'),
                  items: references.map((reference) {
                    return DropdownMenuItem(
                      value: reference,
                      child: Text(reference),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedReference = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: InputDecoration(labelText: 'Levels'),
                  items: levels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLevel = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Slider(
                  value: selectedMaxPrice,
                  min: 0,
                  max: 500.0,
                  divisions: 10,
                  label: 'Max Price: \$${selectedMaxPrice.round()}',
                  onChanged: (value) {
                    setState(() {
                      selectedMaxPrice = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating(List<dynamic> ratings) {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  Widget _buildCourseList(List<Map<String, dynamic>> courses) {
    final filteredCourses = courses.where((course) {
      final matchesSearch = searchQuery.isEmpty || course['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesReference = selectedReference == 'All' || course['reference'] == selectedReference;
      final matchesLevel = selectedLevel == 'All' || course['level']?.toLowerCase().trim() == selectedLevel.toLowerCase().trim();
      return matchesSearch && matchesReference && matchesLevel && (course['price'] == null || course['price'] <= selectedMaxPrice);
    }).toList();

    return ListView.builder(
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        final averageRating = _calculateAverageRating(course['ratings'] ?? []); // Assuming course has 'ratings' field

        // Check if this course is in the paid courses list
        bool isPaid = paidCourses.any((paidCourse) => paidCourse['_id'] == course['_id']); // Ensure 'id' is the correct identifier

        print("Course ID: ${course['_id']} - isPaid: $isPaid"); // Debugging

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResumeDetailsPage(resume: course)),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blueAccent),
              title: Text(course['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Level: ${course['level']}"),
                  Text("Reference: ${course['reference']}"),
                  Text("Owner: ${course['owner']}"),
                  if (course.containsKey('price')) Text("Price: \$${course['price']}"),
                  Text(" Rating: ${averageRating.toStringAsFixed(1)}", style: TextStyle(color: Colors.amber)),
                ],
              ),
              trailing: isPaid
                  ? null // Do not show cart icon if the course is paid
                  : IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => _addToCart(course),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('MoodleStore'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'ShopResume'),
              Tab(text: 'MyCourses'),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          cart: cart,
                          onRemoveFromCart: (course) {
                            setState(() {
                              cart.remove(course);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${course['title']} removed from cart!')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCourseList(unpaidCourses),
                  _buildCourseList(paidCourses),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addCourse,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
