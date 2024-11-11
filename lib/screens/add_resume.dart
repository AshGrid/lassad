import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/resume-service.dart';

class AddResumeScreen extends StatefulWidget {
  @override
  _AddResumeScreenState createState() => _AddResumeScreenState();
}

class _AddResumeScreenState extends State<AddResumeScreen> {
  final _formKey = GlobalKey<FormState>();
  final ResumeService resumeService = ResumeService(); // Create ResumeService instance

  String selectedReference = 'Math';
  List<String> references = ['Math', 'Physics', 'Biology', 'Chemistry'];
  String selectedLevel = 'Beginner';
  List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
  String? resumeTitle;
  double? resumePrice;
  String resumeContentOption = 'Write';
  String? resumeTextContent;
  String? pdfFilePath;

  // Dropdown for selecting reference
  Widget _buildReferenceDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedReference,
      decoration: InputDecoration(labelText: 'Reference'),
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
      validator: (value) => value == null ? 'Please select a reference' : null,
    );
  }

  // Dropdown for selecting level
  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLevel,
      decoration: InputDecoration(labelText: 'Level'),
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
      validator: (value) => value == null ? 'Please select a level' : null,
    );
  }

  // Resume content input widget
  Widget _buildResumeContentInput() {
    if (resumeContentOption == 'Write') {
      return TextFormField(
        maxLines: 5,
        decoration: InputDecoration(labelText: 'Resume Content (Text)'),
        onSaved: (value) {
          resumeTextContent = value;
        },
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );

              if (result != null) {
                setState(() {
                  pdfFilePath = result.files.single.path;
                });
                print("Selected file path: $pdfFilePath");
              }
            },
            child: Text('Upload PDF'),
          ),
          if (pdfFilePath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Selected File: ${pdfFilePath!.split('/').last}'),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Resume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  resumeTitle = value;
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 16),
              _buildReferenceDropdown(),
              SizedBox(height: 16),
              _buildLevelDropdown(),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  resumePrice = double.tryParse(value!);
                },
                validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? 'Please enter a valid price'
                    : null,
              ),
              SizedBox(height: 16),
              Text('Resume Content:'),
              ListTile(
                title: Text('Write'),
                leading: Radio<String>(
                  value: 'Write',
                  groupValue: resumeContentOption,
                  onChanged: (value) {
                    setState(() {
                      resumeContentOption = value!;
                      pdfFilePath = null;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Upload PDF'),
                leading: Radio<String>(
                  value: 'Upload',
                  groupValue: resumeContentOption,
                  onChanged: (value) {
                    setState(() {
                      resumeContentOption = value!;
                      resumeTextContent = null;
                    });
                  },
                ),
              ),
              _buildResumeContentInput(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print('Form is valid.'); // Check if this prints
                    _formKey.currentState!.save();
                    print('Form has been saved.'); // Check if this prints

                    // Prepare the resume data
                    Map<String, dynamic> newResume = {
                      "title": resumeTitle!,
                      "reference": selectedReference,
                      "level": selectedLevel,
                      "price": resumePrice!,
                      "owner": 'YourName', // Replace with actual username
                      "description": resumeTextContent //?? 'No description available.',
                    };
                    print(newResume);

                    // Call the addResume function to send data to backend
                    bool success = await resumeService.addResume(newResume, pdfFilePath);
                    print(success);
                    if (success) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Resume added successfully!')),
                        );
                        // Navigate to the Store screen after successful resume addition
                        Navigator.pushReplacementNamed(context, '/Store');
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add resume')),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
