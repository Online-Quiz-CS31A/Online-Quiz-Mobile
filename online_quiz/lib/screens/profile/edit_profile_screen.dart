import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyContactController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _emergencyContactController = TextEditingController();
    
    // Load user data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadUserData();
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _updateControllersFromState(UserProfileState state) {
    if (state.user != null) {
      if (_bioController.text != state.user!.bio) {
        _bioController.text = state.user!.bio;
      }
      
      // Format phone number by removing +63 prefix if present
      String formattedPhone = state.user!.phoneNumber;
      if (formattedPhone.startsWith('+63 ')) {
        formattedPhone = formattedPhone.substring(4);
      }
      if (_phoneController.text != formattedPhone) {
        _phoneController.text = formattedPhone;
      }
      
      // Format emergency contact by removing +63 prefix if present
      String formattedEmergency = state.user!.emergencyContact;
      if (formattedEmergency.startsWith('+63 ')) {
        formattedEmergency = formattedEmergency.substring(4);
      }
      if (_emergencyContactController.text != formattedEmergency) {
        _emergencyContactController.text = formattedEmergency;
      }
    }
  }

  void _pickImageFromGallery() {
    // TODO: Implement image picker from gallery
    // After setting the image URL, call:
    // ref.read(userProfileProvider.notifier).updateProfileImageUrl(imageUrl);
  }

  void _pickImageFromCamera() {
    // TODO: Implement image picker from camera
    // After setting the image URL, call:
    // ref.read(userProfileProvider.notifier).updateProfileImageUrl(imageUrl);
  }

  void _removeProfilePicture() {
    ref.read(userProfileProvider.notifier).updateProfileImageUrl('');
  }

  void _showImagePickerOptions() {
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
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Photo'),
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

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    
    // Update controllers when state changes
    _updateControllersFromState(profileState);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: profileState.isLoading || !profileState.hasChanges
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await ref.read(userProfileProvider.notifier).saveProfile();
                        if (mounted && profileState.error == null) {
                          if (context.mounted) Navigator.pop(context);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: profileState.hasChanges && !profileState.isLoading
                    ? Colors.white
                    : Colors.grey[300],
                foregroundColor: profileState.hasChanges && !profileState.isLoading
                    ? Colors.blue[600]
                    : Colors.grey[600],
                elevation: profileState.hasChanges && !profileState.isLoading ? 2 : 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: profileState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: profileState.isLoading && profileState.user == null
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${profileState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(userProfileProvider.notifier).loadUserData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
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
                                    backgroundImage: profileState.user?.profileImageUrl.isNotEmpty == true
                                        ? (profileState.user!.profileImageUrl.startsWith('assets/')
                                            ? AssetImage(profileState.user!.profileImageUrl)
                                            : NetworkImage(profileState.user!.profileImageUrl))
                                        : AssetImage('assets/images/aclclogo-nobg.png'),
                                    child: null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _showImagePickerOptions,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[600],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profileState.user?.name ?? 'User Name',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileState.user?.email ?? 'user@example.com',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Student ID: ${profileState.user?.studentId ?? 'Not specified'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Course Information (Read-only)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.school,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Degree Program',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profileState.user?.degree ?? 'Not specified',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Bio Field
                        const Text(
                          'Bio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bioController,
                          maxLines: 4,
                          maxLength: 500,
                          onChanged: (value) {
                            ref.read(userProfileProvider.notifier).updateBio(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Tell us about yourself...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue[600]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bio cannot be empty';
                            }
                            if (value.trim().length < 10) {
                              return 'Bio must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Phone Number Field
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            ref.read(userProfileProvider.notifier).updatePhoneNumber(value);
                          },
                          decoration: InputDecoration(
                            prefixText: '+63 | ',
                            prefixStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: '123 456 7890',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue[600]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            if (!RegExp(r'^\d{3}\s\d{3}\s\d{4}$').hasMatch(value.trim())) {
                              return 'Please enter a valid phone number (123 456 7890)';
                            }
                            if (value.trim() == _emergencyContactController.text.trim()) {
                              return 'Phone number cannot be the same as emergency contact';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Emergency Contact Field
                        const Text(
                          'Emergency Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emergencyContactController,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            ref.read(userProfileProvider.notifier).updateEmergencyContact(value);
                          },
                          decoration: InputDecoration(
                            prefixText: '+63 | ',
                            prefixStyle: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: '987 654 3210',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue[600]!),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Emergency contact is required';
                            }
                            if (!RegExp(r'^\d{3}\s\d{3}\s\d{4}$').hasMatch(value.trim())) {
                              return 'Please enter a valid emergency contact (987 654 3210)';
                            }
                            if (value.trim() == _phoneController.text.trim()) {
                              return 'Emergency contact cannot be the same as phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }
}