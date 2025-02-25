import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/services/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/utils/location_utils.dart';

class FilterBottomSheet extends StatefulWidget {
  final String initialLocation;
  final int? initialCategoryId;
  final Function(
          String location, int? categoryId, String date, RangeValues priceRange)
      onApplyFilter;

  const FilterBottomSheet({
    super.key,
    this.initialLocation = '',
    this.initialCategoryId,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _minPrice = 40;
  double _maxPrice = 120;
  late String _selectedLocation;
  late String _selectedDate;
  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryId;
  bool _isLoadingCategories = false;
  final TextEditingController _locationController = TextEditingController();

  // Cache key and expiration time (1 hour for categories since they change less frequently)
  static const String _categoriesCacheKey = 'categories_data';
  final Duration _cacheExpiration = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _locationController.text = _selectedLocation;
    _selectedCategoryId = widget.initialCategoryId;

    // Set date to today
    final now = DateTime.now();
    _selectedDate = '${now.day} ${_getMonthName(now.month)} ${now.year}';

    // Clear the categories cache to force a fresh fetch
    _clearCategoriesCache();
    _fetchCategories();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // Save categories to cache
  Future<void> _saveCategoriesToCache(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert the list to a JSON string
      final jsonData = jsonEncode(data);

      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': jsonData,
      };

      await prefs.setString(_categoriesCacheKey, jsonEncode(cacheData));
      debugPrint(
          'DEBUG: Saved categories to cache: ${data.map((c) => "${c['id']}: ${c['name']}").join(", ")}');
    } catch (e) {
      debugPrint('DEBUG: Error saving categories to cache: $e');
    }
  }

  // Get categories from cache
  Future<List<Map<String, dynamic>>?> _getCategoriesFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(_categoriesCacheKey);

      if (cachedString == null) {
        debugPrint('DEBUG: No categories cache found');
        return null;
      }

      final cachedData = jsonDecode(cachedString);
      final timestamp = cachedData['timestamp'];
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if cache is expired
      if (now - timestamp > _cacheExpiration.inMilliseconds) {
        debugPrint('DEBUG: Categories cache expired');
        return null;
      }

      final dataString = cachedData['data'];
      final List<dynamic> rawData = jsonDecode(dataString);

      // Convert each item to a Map<String, dynamic>
      final List<Map<String, dynamic>> data = rawData.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();

      debugPrint(
          'DEBUG: Retrieved categories from cache: ${data.length} items');
      debugPrint(
          'DEBUG: Cache data sample: ${data.isNotEmpty ? jsonEncode(data[0]) : "empty"}');

      return data;
    } catch (e) {
      debugPrint('DEBUG: Error getting categories from cache: $e');
      // Clear the corrupted cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_categoriesCacheKey);
      return null;
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      // Try to get data from cache first
      final cachedData = await _getCategoriesFromCache();
      if (cachedData != null) {
        setState(() {
          _categories = cachedData;
          _isLoadingCategories = false;
        });
        debugPrint(
            'DEBUG: Using cached categories data: ${_categories.map((c) => "${c['id']}: ${c['name']}").join(", ")}');
        return;
      }

      // Get auth token from provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        debugPrint('DEBUG: No authentication token available');
        setState(() {
          _isLoadingCategories = false;
        });
        return;
      }

      debugPrint('DEBUG: Fetching categories from API');
      final response = await http.get(
        Uri.parse(ApiConstants.categories),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'DEBUG: Categories API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('DEBUG: Raw categories data: $data');

        // Extract categories from the response
        final List<dynamic> rawCategories = data['data'] ?? [];
        final List<Map<String, dynamic>> categoriesList =
            rawCategories.map((category) {
          return {
            'id': category['id'],
            'name': category['attributes']['name'],
            'slug': category['attributes']['slug'],
          };
        }).toList();

        debugPrint(
            'DEBUG: Processed ${categoriesList.length} categories: ${categoriesList.map((c) => "${c['id']}: ${c['name']}").join(", ")}');

        // Save to cache
        await _saveCategoriesToCache(categoriesList);

        setState(() {
          _categories = categoriesList;
          _isLoadingCategories = false;
        });
      } else {
        debugPrint('DEBUG: Categories API error: ${response.body}');
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      debugPrint('DEBUG: Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 40), // Balance the header
              ],
            ),
          ),

          // Divider line
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Filter title
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Filter Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Section
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Locations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter location',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                suffixIcon: _locationController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.grey, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _locationController.clear();
                                            _selectedLocation = '';
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                _selectedLocation = value;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          CircularLocationButton(
                            onLocationSelected: (location) {
                              setState(() {
                                _selectedLocation = location;
                                _locationController.text = location;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Categories Section
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 12),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _isLoadingCategories
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _categories.length + 1, // +1 for "All" option
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _buildCategoryChip('All', null);
                                } else {
                                  final category = _categories[index - 1];
                                  final name =
                                      category['name'] as String? ?? 'Unknown';
                                  final id = category['id'];
                                  final icon = _getCategoryIcon(name);
                                  return _buildCategoryChip(name, id,
                                      icon: icon);
                                }
                              },
                            ),
                          ),

                    // Dates
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 12),
                      child: Text(
                        'Dates',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedDate,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF2196F3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.white, size: 20),
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: Color(0xFF2196F3),
                                          onPrimary: Colors.white,
                                          surface: Color(0xFF2C2C2E),
                                          onSurface: Colors.white,
                                        ),
                                        dialogTheme: const DialogThemeData(
                                            backgroundColor: Color(0xFF121212)),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setState(() {
                                    _selectedDate =
                                        '${picked.day} ${_getMonthName(picked.month)} ${picked.year}';
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price Range
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price Range',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price range slider with custom thumbs
                    SizedBox(
                      height: 80,
                      child: Stack(
                        children: [
                          // Bar chart background
                          Positioned.fill(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                8,
                                (index) => Container(
                                  width: 20,
                                  height: 30 + (index % 4) * 10.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2E),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Slider
                          Positioned.fill(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2,
                                activeTrackColor: const Color(0xFF2196F3),
                                inactiveTrackColor: Colors.grey.shade800,
                                thumbColor: Colors.white,
                                overlayColor: Colors.transparent,
                                rangeThumbShape: _CustomRangeThumbShape(),
                                showValueIndicator: ShowValueIndicator.never,
                              ),
                              child: RangeSlider(
                                values: RangeValues(_minPrice, _maxPrice),
                                min: 0,
                                max: 200,
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _minPrice = values.start;
                                    _maxPrice = values.end;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Apply Filter and Clear All Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
                24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
            child: Column(
              children: [
                // Clear All Filters button
                if (_selectedLocation.isNotEmpty ||
                    _selectedCategoryId != null ||
                    _selectedDate !=
                        '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}' ||
                    _minPrice != 40 ||
                    _maxPrice != 120)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = '';
                          _locationController.clear();
                          _selectedCategoryId = null;
                          final now = DateTime.now();
                          _selectedDate =
                              '${now.day} ${_getMonthName(now.month)} ${now.year}';
                          _minPrice = 40;
                          _maxPrice = 120;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.filter_list_off,
                              color: Colors.blue, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Clear All Filters',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Apply Filter Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4169E8),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        widget.onApplyFilter(
                          _selectedLocation,
                          _selectedCategoryId,
                          _selectedDate,
                          RangeValues(_minPrice, _maxPrice),
                        );
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          'Apply Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Home indicator
          Container(
            height: 5,
            width: 134,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, dynamic categoryId,
      {IconData? icon}) {
    // Convert categoryId to int for comparison if it's not null
    final int? categoryIdInt =
        categoryId != null ? int.tryParse(categoryId.toString()) : null;

    final isSelected = categoryIdInt == _selectedCategoryId ||
        (categoryIdInt == null && _selectedCategoryId == null);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategoryId = categoryIdInt;
            });
            debugPrint('DEBUG: Selected category: $label (ID: $categoryIdInt)');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4169E8)
                  : const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label == "Music" && isSelected) ...[
                  const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                ] else if (label != "All" && icon != null) ...[
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData? _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('all')) return Icons.category;
    if (name.contains('arts') || name.contains('culture')) return Icons.palette;
    if (name.contains('business') || name.contains('finance'))
      return Icons.business;
    if (name.contains('community')) return Icons.people;
    if (name.contains('education')) return Icons.school;
    if (name.contains('entertainment')) return Icons.movie;
    if (name.contains('food') || name.contains('drink'))
      return Icons.restaurant;
    if (name.contains('health') || name.contains('wellness'))
      return Icons.favorite;
    if (name.contains('music')) return Icons.music_note;
    if (name.contains('sports') || name.contains('fitness'))
      return Icons.sports_basketball;
    if (name.contains('tech') || name.contains('technology'))
      return Icons.computer;
    if (name.contains('travel') || name.contains('outdoor'))
      return Icons.landscape;
    return Icons.event; // Default icon
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Add a method to clear the categories cache
  Future<void> _clearCategoriesCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_categoriesCacheKey);
      debugPrint('DEBUG: Categories cache cleared');
    } catch (e) {
      debugPrint('DEBUG: Error clearing categories cache: $e');
    }
  }
}

// Custom thumb shape for the range slider
class _CustomRangeThumbShape extends RangeSliderThumbShape {
  static const double _thumbRadius = 16.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    // Draw outer circle (blue)
    final Paint outerPaint = Paint()
      ..color = const Color(0xFF4169E8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, _thumbRadius, outerPaint);

    // Draw inner circle (white)
    final Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, _thumbRadius - 4, innerPaint);

    // Draw arrow icon
    final Paint arrowPaint = Paint()
      ..color = const Color(0xFF4169E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left/right arrow based on which thumb
    if (thumb == Thumb.start) {
      // Left arrow
      final path = Path()
        ..moveTo(center.dx + 3, center.dy - 4)
        ..lineTo(center.dx - 3, center.dy)
        ..lineTo(center.dx + 3, center.dy + 4);
      canvas.drawPath(path, arrowPaint);
    } else {
      // Right arrow
      final path = Path()
        ..moveTo(center.dx - 3, center.dy - 4)
        ..lineTo(center.dx + 3, center.dy)
        ..lineTo(center.dx - 3, center.dy + 4);
      canvas.drawPath(path, arrowPaint);
    }
  }
}
