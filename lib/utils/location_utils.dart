import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationUtils {
  /// Gets the user's current location and returns just the province or city name
  /// Returns null if there was an error or permission was denied
  static Future<String?> getCurrentLocation(BuildContext context) async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission still denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return 'Phnom Penh'; // Default to Phnom Penh instead of null
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // User denied permission forever
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission permanently denied. Please enable in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
        return 'Phnom Penh'; // Default to Phnom Penh instead of null
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint(
          'Location coordinates: ${position.latitude}, ${position.longitude}');

      // Check if we're likely in an emulator/simulator
      final bool isEmulator = await _isRunningOnEmulator(position);

      if (isEmulator) {
        debugPrint('Running on emulator/simulator, using default location');
        return 'Phnom Penh';
      }

      // Get place name from coordinates
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        debugPrint('Raw placemark data: $place');

        // Check if we're in Cambodia
        final String countryCode = place.isoCountryCode ?? '';

        if (countryCode == 'KH') {
          // We're in Cambodia, use the actual location
          String? locationName;

          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            locationName = place.administrativeArea;
          } else if (place.locality != null && place.locality!.isNotEmpty) {
            locationName = place.locality;
          } else if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty) {
            locationName = place.subAdministrativeArea;
          } else {
            locationName = 'Phnom Penh';
          }

          return locationName;
        } else {
          // We're not in Cambodia
          // Return the actual location name for non-Cambodia real devices
          String? locationName;

          if (place.locality != null && place.locality!.isNotEmpty) {
            locationName = place.locality;
          } else if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            locationName = place.administrativeArea;
          } else if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty) {
            locationName = place.subAdministrativeArea;
          } else {
            locationName = 'Phnom Penh';
          }

          return locationName;
        }
      } else {
        return 'Phnom Penh'; // Default if no placemark found
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
      return 'Phnom Penh'; // Default on error
    }
  }

  /// Checks if the app is likely running on an emulator/simulator
  static Future<bool> _isRunningOnEmulator(Position position) async {
    // Method 1: Check for common emulator coordinates
    // Many emulators default to specific locations like Mountain View, CA
    if ((position.latitude == 37.4219983 &&
            position.longitude == -122.084) || // Android emulator default
        (position.latitude == 37.785834 && position.longitude == -122.406417)) {
      // iOS simulator default
      return true;
    }

    // Method 2: Check for suspiciously perfect coordinates
    // Real GPS usually has some decimal precision, not perfectly round numbers
    if (position.latitude == position.latitude.roundToDouble() &&
        position.longitude == position.longitude.roundToDouble()) {
      return true;
    }

    // Method 3: Check for very low accuracy
    // Emulators often report perfect accuracy or very low values
    if (position.accuracy < 1.0) {
      return true;
    }

    // Method 4: Check for zero altitude, speed, or heading
    // Many emulators don't properly simulate these values
    if (position.altitude == 0 &&
        position.speed == 0 &&
        position.heading == 0) {
      return true;
    }

    // Additional check: Try to detect emulator through platform channels
    // This is a simplified approach - in a real app you might want to use
    // a plugin like device_info_plus to get more detailed information
    try {
      final String model = await _getDeviceModel();
      if (model.toLowerCase().contains('emulator') ||
          model.toLowerCase().contains('simulator')) {
        return true;
      }
    } catch (e) {
      // Ignore errors in this check
    }

    return false;
  }

  /// Gets the device model name
  static Future<String> _getDeviceModel() async {
    // This is a placeholder - in a real app, you would use
    // device_info_plus or another plugin to get the actual model
    // For now, we'll just return a default value
    return 'unknown';
  }

  /// Returns a random Cambodian location for testing purposes
  static String _getRandomCambodianLocation() {
    final List<String> cambodianLocations = [
      'Phnom Penh',
      'Siem Reap',
      'Battambang',
      'Sihanoukville',
      'Kampot',
      'Kep',
      'Kampong Cham',
      'Kratie',
      'Mondulkiri',
      'Ratanakiri',
    ];

    // Get a deterministic "random" location based on the current minute
    // This ensures we don't get a different location every time during testing
    final int minute = DateTime.now().minute;
    final int index = minute % cambodianLocations.length;

    return cambodianLocations[index];
  }
}

/// A reusable location button widget
class LocationButton extends StatefulWidget {
  final Function(String) onLocationSelected;
  final Color buttonColor;
  final String initialText;

  const LocationButton({
    super.key,
    required this.onLocationSelected,
    this.buttonColor = const Color(0xFF4169E8),
    this.initialText = 'My Current Location',
  });

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool _isLoading = false;
  String _buttonText = '';

  @override
  void initState() {
    super.initState();
    _buttonText = widget.initialText;
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
    });

    final location = await LocationUtils.getCurrentLocation(context);

    setState(() {
      _isLoading = false;
      if (location != null) {
        _buttonText = location;
        widget.onLocationSelected(location);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: _getLocation,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}

/// A circular location button for use in input fields
class CircularLocationButton extends StatefulWidget {
  final Function(String) onLocationSelected;
  final Color buttonColor;

  const CircularLocationButton({
    super.key,
    required this.onLocationSelected,
    this.buttonColor = const Color(0xFF4169E8),
  });

  @override
  State<CircularLocationButton> createState() => _CircularLocationButtonState();
}

class _CircularLocationButtonState extends State<CircularLocationButton> {
  bool _isLoading = false;

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
    });

    final location = await LocationUtils.getCurrentLocation(context);

    setState(() {
      _isLoading = false;
    });

    if (location != null) {
      widget.onLocationSelected(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.buttonColor,
        shape: BoxShape.circle,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : IconButton(
              icon:
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
              onPressed: _getLocation,
            ),
    );
  }
}
