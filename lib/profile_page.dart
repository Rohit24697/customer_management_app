import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'customer_list_screen.dart';
import 'database/database_helper.dart';
import 'models/customer.dart';
import 'full_screen_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final customer = Customer(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _mobileController.text,
        address: _addressController.text,
        imagePath: _imageFile!.path,
      );

      await DatabaseHelper.instance.insertCustomer(customer);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer saved successfully")),
      );

      _clearForm();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CustomerListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a profile image")),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (!mounted) return;

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove"),
              onTap: () {
                Navigator.pop(context);
                if (!mounted) return;
                setState(() => _imageFile = null);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _addressController.clear();
    setState(() => _imageFile = null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Customer'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    if (_imageFile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImage(imageFile: _imageFile!),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          image: _imageFile != null
                              ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _imageFile == null
                            ? Icon(Icons.person_2, size: 80.0, color: Colors.grey.shade800)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _showImageSourceDialog,
                          child: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 20.0,
                            child: Icon(Icons.camera_alt_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                _buildTextField(
                  label: "Name",
                  controller: _nameController,
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Name is required';
                    if (value.length <= 3) return 'Name must be more than 3 letters';
                    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) return "Only letters allowed";
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Email",
                  controller: _emailController,
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Mobile",
                  controller: _mobileController,
                  icon: Icons.phone_android,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    if (value.length != 10) return 'Enter 10-digit number';
                    return null;
                  },
                ),
                _buildTextField(
                  label: "Address",
                  controller: _addressController,
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Address is required';
                    if (value.length < 5) return 'At least 5 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _clearForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Form cleared")),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Clear"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        validator: validator,
      ),
    );
  }
}
