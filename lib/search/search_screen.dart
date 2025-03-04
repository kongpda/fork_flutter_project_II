import 'package:flutter/material.dart';
import 'package:flutter_project_ii/search/filter_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project_ii/services/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/widgets/event_card.dart';
import 'package:flutter_project_ii/utils/location_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _events = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _location = '';
  int? _categoryId;
  int? _organizerId;

  // Cache expiration time (5 minutes)
  final Duration _cacheExpiration = const Duration(minutes: 5);

  // Add this variable
  final bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Generate a cache key based on search parameters
  String _getCacheKey() {
    final List<String> keyParts = [];

    // Base key
    keyParts.add('events');

    // Add search parameters if they exist
    if (_searchQuery.isNotEmpty) keyParts.add('q:${_searchQuery.trim()}');
    if (_location.isNotEmpty) keyParts.add('loc:${_location.trim()}');
    if (_categoryId != null) keyParts.add('cat:$_categoryId');
    if (_organizerId != null) keyParts.add('org:$_organizerId');

    // If no parameters, add 'all' to indicate all events
    if (keyParts.length == 1) keyParts.add('all');

    // Join with hyphens for better readability
    return keyParts.join('-');
  }

  // Save data to cache
  Future<void> _saveToCache(String key, List<dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': jsonEncode(data),
      };
      await prefs.setString(key, jsonEncode(cacheData));
      debugPrint('DEBUG: Saved data to cache with key: $key');
    } catch (e) {
      debugPrint('DEBUG: Error saving to cache: $e');
    }
  }

  // Get data from cache
  Future<List<dynamic>?> _getFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedString = prefs.getString(key);

      if (cachedString == null) {
        debugPrint('DEBUG: No cache found for key: $key');
        return null;
      }

      final cachedData = jsonDecode(cachedString);
      final timestamp = cachedData['timestamp'];
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if cache is expired
      if (now - timestamp > _cacheExpiration.inMilliseconds) {
        debugPrint('DEBUG: Cache expired for key: $key');
        return null;
      }

      final data = jsonDecode(cachedData['data']);
      debugPrint('DEBUG: Retrieved data from cache with key: $key');
      return data;
    } catch (e) {
      debugPrint('DEBUG: Error getting from cache: $e');
      return null;
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    final cacheKey = _getCacheKey();

    try {
      // Try to get data from cache first
      final cachedData = await _getFromCache(cacheKey);
      if (cachedData != null) {
        setState(() {
          _events = cachedData;
          _isLoading = false;
        });
        debugPrint('DEBUG: Using cached events data');
        return;
      }

      // Get auth token from provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        debugPrint('DEBUG: No authentication token available');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Build query parameters
      final queryParams = <String, String>{};
      if (_searchQuery.isNotEmpty) queryParams['search'] = _searchQuery;
      if (_location.isNotEmpty) queryParams['location'] = _location;
      if (_categoryId != null)
        queryParams['category_id'] = _categoryId.toString();
      if (_organizerId != null)
        queryParams['organizer_id'] = _organizerId.toString();

      debugPrint('DEBUG: Fetching events with params: $queryParams');

      final uri =
          Uri.parse(ApiConstants.events).replace(queryParameters: queryParams);
      debugPrint('DEBUG: API URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('DEBUG: Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint(
            'DEBUG: Received events data: ${data['data']?.length} items');

        final eventsList = data['data'] ?? [];

        // Save to cache
        await _saveToCache(cacheKey, eventsList);

        setState(() {
          _events = eventsList;
          _isLoading = false;
        });
      } else {
        debugPrint('DEBUG: API error response: ${response.body}');
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('DEBUG: Error fetching events: $e');
    }
  }

  void _applyFilters(
      String location, int? categoryId, String date, RangeValues priceRange) {
    debugPrint(
        'DEBUG: Applying filters - Location: $location, Category: $categoryId, Date: $date, Price: $priceRange');
    setState(() {
      _location = location;
      _categoryId = categoryId;
      // Note: The API doesn't seem to have date and price range parameters in the example
      // but we're storing the values for future implementation
    });
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1C1C1E), // Dark background color
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 44,
                      decoration: BoxDecoration(
                        color: _searchController.text.isNotEmpty
                            ? const Color(
                                0xFF3A3A3C) // Slightly lighter when has text
                            : const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: _searchController.text.isNotEmpty
                                  ? Colors.blue
                                  : Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              onChanged: (value) {
                                // Force rebuild to show/hide the clear button and update colors
                                setState(() {});
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                                _fetchEvents();
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Search events...',
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear,
                                            color: Colors.blue, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = '';
                                          });
                                          _fetchEvents();
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.blue),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FilterBottomSheet(
                            initialLocation: _location,
                            initialCategoryId: _categoryId,
                            onApplyFilter: _applyFilters,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Location Button and Clear All Filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  LocationButton(
                    onLocationSelected: (location) {
                      setState(() {
                        _location = location;
                      });
                      _fetchEvents();
                    },
                    initialText:
                        _location.isEmpty ? 'My Current Location' : _location,
                  ),

                  // Only show Clear All Filters if any filter is applied
                  if (_searchQuery.isNotEmpty ||
                      _location.isNotEmpty ||
                      _categoryId != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                            _location = '';
                            _categoryId = null;
                            _organizerId = null;
                          });
                          _fetchEvents();
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
                ],
              ),
            ),

            // Event List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _events.isEmpty
                      ? const Center(
                          child: Text(
                            'No events found',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            final event = _events[index];
                            final attributes = event['attributes'] ?? {};

                            // Format the date
                            String formattedDate = 'No date';
                            if (attributes['start_date'] != null) {
                              final startDate =
                                  DateTime.parse(attributes['start_date']);
                              formattedDate =
                                  '${startDate.day} ${_getMonthName(startDate.month)} ${startDate.year}';
                            }

                            return EventCard(
                              date: formattedDate,
                              title: attributes['title'] ?? 'No title',
                              imageUrl: attributes['feature_image'] ??
                                  'assets/images/event-one.jpg',
                              eventId: event['id'],
                              isFavorited: attributes['is_favorited'] ?? false,
                              isPaticipant: attributes['is_participant'] ?? false,
                              favoritesCount:
                                  attributes['favorites_count'] ?? 0,
                              toggleFavoriteUrl: event['links']
                                  ?['toggleFavorite'],
                              onFavoriteToggled: () {
                                // Refresh the events list to get updated favorite counts
                                _fetchEvents();
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
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
}
