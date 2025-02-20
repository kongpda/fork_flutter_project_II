import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/create/event_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project_ii/api_module/create/event_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  File? _imageFile;  // Add this line at the start of the class

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _catCtrl = TextEditingController();
  final _capCtrl = TextEditingController();

  String? _participantsType;
  String? _eventType;
  String? _status;

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      // Replace these with your actual Cloudinary credentials
      final cloudName = 'dchutnzwv';
      final uploadPreset = 'flutter';
      
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      
      // Create multipart request
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${response.body}');
      }

      final jsonData = jsonDecode(response.body);
      return jsonData['secure_url'];
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Event',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,  // Update this line
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_photo_alternate, size: 50),
                            SizedBox(height: 8),
                            Text('Add Event Image'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[900]!),
                  ),
                ),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startCtrl,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Start date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endCtrl,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'End date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locCtrl,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.location_on),
                ),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _catCtrl,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      value: _participantsType,
                      decoration: const InputDecoration(
                        labelText: 'Participants type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [

                        DropdownMenuItem(value: 'paid', child: Text('Paid', style: TextStyle(fontSize: 16, color: Colors.black))),
                        DropdownMenuItem(value: 'free', child: Text('Free', style: TextStyle(fontSize: 16, color: Colors.black))),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _participantsType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _capCtrl,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      border: OutlineInputBorder(),
                      prefixText: 'Person',
                    ),
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      value: _eventType,
                      decoration: const InputDecoration(
                        labelText: 'Event type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'online', child: Text('online', style: TextStyle(fontSize: 16, color: Colors.black))),
                        DropdownMenuItem(value: 'in_person', child: Text('in_person', style: TextStyle(fontSize: 16, color: Colors.black))),
                        DropdownMenuItem(value: 'hybrid', child: Text('hybrid', style: TextStyle(fontSize: 16, color: Colors.black))),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _eventType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('Open')),
                        DropdownMenuItem(value: 'closed', child: Text('Closed')),
                        DropdownMenuItem(value: 'full', child: Text('Full')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _status = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(child: CircularProgressIndicator());
                        },
                      );

                      String? imageUrl;
                      if (_imageFile != null) {
                        imageUrl = await _uploadImageToCloudinary(_imageFile!);
                        if (imageUrl == null) {
                          Navigator.pop(context); // Dismiss loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to upload image')),
                          );
                          return;
                        }
                      }

                      final event = Event(
                        name: _nameCtrl.text,
                        description: _descCtrl.text,
                        startDate: _startCtrl.text,
                        endDate: _endCtrl.text,
                        location: _locCtrl.text,
                        category: _catCtrl.text,
                        capacity: _capCtrl.text,
                        participantsType: _participantsType ?? '',
                        eventType: _eventType ?? '',
                        status: _status ?? '',
                        imageUrl: imageUrl, // Update the Event model to accept imageUrl instead of imageFile
                      );

                      final success = await Provider.of<EventProvider>(context, listen: false)
                          .createEvent(context, event);

                      Navigator.pop(context); // Dismiss loading indicator

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event created successfully!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to create event')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Create Event',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}