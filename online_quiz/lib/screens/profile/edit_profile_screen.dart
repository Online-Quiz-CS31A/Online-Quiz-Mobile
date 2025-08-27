import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/info_card.dart';
import '../../models/mock_data.dart';
import '../../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  
  bool _isLoading = false;
  
  // Mock data use for early development
  String _profileImageUrl = '';
  late User _user;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  void _loadUserData() {
    // Load mock user data
    _user = DummyData.getUser();
    _bioController.text = _user.bio ?? '';
    _phoneController.text = _user.phoneNumber ?? '';
    _emergencyContactController.text = _user.emergencyContact ?? '';
  }
  
  @override
  void dispose() {
    _bioController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImageUrl.isNotEmpty 
                              ? NetworkImage(_profileImageUrl) 
                              : null,
                          child: _profileImageUrl.isEmpty 
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _changeProfilePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to change profile picture',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Read-only Academic Information
              _buildSectionHeader('Academic Information'),
              const Text(
                'The following information is managed by school administration and cannot be edited:',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              
              InfoCard(
                 icon: Icons.badge,
                 title: 'Student ID',
                 value: _user.studentId,
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
               const SizedBox(height: 12),
               
               InfoCard(
                 icon: Icons.person,
                 title: 'Full Name',
                 value: _user.name,
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
               const SizedBox(height: 12),
               
               InfoCard(
                 icon: Icons.email,
                 title: 'Email',
                 value: _user.email,
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
               const SizedBox(height: 12),
               
               InfoCard(
                 icon: Icons.school,
                 title: 'Course',
                 value: 'Bachelor of Science in Computer Science',
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
               const SizedBox(height: 12),
               
               InfoCard(
                 icon: Icons.grade,
                 title: 'Year Level',
                 value: '3rd Year',
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
               const SizedBox(height: 12),
               
               InfoCard(
                 icon: Icons.class_,
                 title: 'Section',
                 value: 'CS-3A',
                 backgroundColor: Colors.grey[100],
                 iconColor: Colors.grey[600],
                 titleColor: Colors.black87,
                 valueColor: Colors.black54,
                 trailing: Icon(
                   Icons.lock_outline,
                   size: 16,
                   color: Colors.grey[400],
                 ),
                 showBorder: true,
                 borderColor: Colors.grey[300],
                 padding: const EdgeInsets.all(16),
               ),
              
              const SizedBox(height: 32),
              
              // Editable Personal Information
              _buildSectionHeader('Personal Information'),
              const Text(
                'You can update the following personal details:',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _bioController,
                labelText: 'Bio',
                hintText: 'Tell us about yourself...',
                maxLines: 3,
                validator: (value) {
                  if (value != null && value.length > 200) {
                    return 'Bio must be less than 200 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'XXX XXX XXXX',
                  prefixText: '+63 | ',
                  prefixStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{3}\s\d{3}\s\d{4}\$').hasMatch(value)) {
                      return 'Please enter a valid phone number (XXX XXX XXXX)';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emergencyContactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Emergency Contact',
                  hintText: 'XXX XXX XXXX',
                  prefixText: '+63 | ',
                  prefixStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{3}\s\d{3}\s\d{4}\$').hasMatch(value)) {
                      return 'Please enter a valid phone number (XXX XXX XXXX)';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Information Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'To update academic information, please contact the school registrar or administration office.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  

  
  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              if (_profileImageUrl.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  
  void _pickImageFromGallery() {
    // TODO: Implement image picker from gallery (buhaton rani nako - deadline: Midterms)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery picker will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _pickImageFromCamera() {
    // TODO: Implement image picker from camera (buhaton rani nako - deadline: Midterms)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera picker will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _removeProfilePicture() {
    setState(() {
      _profileImageUrl = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: Colors.orange,
      ),
    );
  }
  
  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Implement actual save functionality (buhaton rani nako - deadline: Midterms)
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}