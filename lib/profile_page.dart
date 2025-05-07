// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'customer_list_screen.dart';
// import 'database/shared_preferences_helper.dart';
// import 'full_screen_image.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _addressController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedData();
//   }
//
//   Future<void> _loadSavedData() async {
//     final data = await SharedPreferencesHelper.loadProfileData();
//     final prefs = await SharedPreferences.getInstance();
//     final savedImagePath = prefs.getString("profile_image");
//
//     if (!mounted) return; // Ensure widget is still in tree
//
//     setState(() {
//       _nameController.text = data['name'] ?? '';
//       _emailController.text = data['email'] ?? '';
//       _mobileController.text = data['mobile'] ?? '';
//       _addressController.text = data['address'] ?? '';
//       if (savedImagePath != null && File(savedImagePath).existsSync()) {
//         _imageFile = File(savedImagePath);
//       }
//     });
//   }
//
//   Future<void> _saveData() async {
//     if (_formKey.currentState!.validate()) {
//       await SharedPreferencesHelper.saveProfileData(
//         name: _nameController.text,
//         email: _emailController.text,
//         mobile: _mobileController.text,
//         address: _addressController.text,
//         imagePath: _imageFile?.path ?? '',
//       );
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User saved successfully")),
//       );
//
//       // Navigate to CustomerListScreen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => CustomerListScreen()), // Replace with your actual CustomerListScreen widget
//       );
//     }
//   }
//
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
//     if (!mounted) return;
//
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//
//       final prefs = await SharedPreferences.getInstance();
//       if (!mounted) return; // Ensure widget is still in tree
//       await prefs.setString("profile_image", pickedFile.path);
//     }
//   }
//
//   Future<void> _showImageSourceDialog() async {
//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Select Image Source"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Camera"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Gallery"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete),
//               title: const Text("Remove"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 if (!mounted) return;
//                 setState(() => _imageFile = null);
//                 final prefs = await SharedPreferences.getInstance();
//                 if (!mounted) return;
//                 await prefs.remove("profile_image");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // @override
//   // void dispose() {
//   //   _nameController.dispose();
//   //   _emailController.dispose();
//   //   _mobileController.dispose();
//   //   _addressController.dispose();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile Registration'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 16.0),
//                 GestureDetector(
//                   onTap: () {
//                     if (_imageFile != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => FullScreenImage(imageFile: _imageFile!),
//                         ),
//                       );
//                     }
//                   },
//                   child:
//                   Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (_imageFile != null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => FullScreenImage(imageFile: _imageFile!),
//                               ),
//                             );
//                           }
//                         },
//                         child: Container(
//                           width: 150,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             shape: BoxShape.circle,
//                             image: _imageFile != null
//                                 ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
//                                 : null,
//                           ),
//                           child: _imageFile == null
//                               ? Icon(
//                             Icons.person_2,
//                             size: 80.0,
//                             color: Colors.grey.shade800,
//                           )
//                               : null,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: InkWell(
//                           onTap: _showImageSourceDialog,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.blue,
//                             radius: 20.0,
//                             child: Icon(
//                               Icons.camera_alt_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24.0),
//
//                 // Name
//                 _buildTextField(
//                   label: "Name",
//                   controller: _nameController,
//                   icon: Icons.person,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Name is required';
//                     if (value.length <= 3) return 'Name must be more than 3 letters';
//                     if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) return "Only letters allowed";
//                     return null;
//                   },
//                 ),
//
//                 // Email
//                 _buildTextField(
//                   label: "Email",
//                   controller: _emailController,
//                   icon: Icons.email,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Email is required';
//                     if (!value.contains('@')) return 'Invalid email';
//                     return null;
//                   },
//                 ),
//
//                 // Mobile
//                 _buildTextField(
//                   label: "Mobile",
//                   controller: _mobileController,
//                   icon: Icons.phone_android,
//                   inputType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(10),
//                   ],
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Phone number is required';
//                     if (value.length != 10) return 'Enter 10-digit number';
//                     return null;
//                   },
//                 ),
//
//                 // Address
//                 _buildTextField(
//                   label: "Address",
//                   controller: _addressController,
//                   icon: Icons.home,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Address is required';
//                     if (value.length < 5) return 'At least 5 characters';
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 30.0),
//
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _saveData,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
//                       child: const Text("Save"),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         _nameController.clear();
//                         _emailController.clear();
//                         _mobileController.clear();
//                         _addressController.clear();
//                         final prefs = await SharedPreferences.getInstance();
//                         await prefs.remove("profile_image");
//                         if (!mounted) return;
//                         setState(() => _imageFile = null);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Profile data cleared")),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                       child: const Text("Clear"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     required String? Function(String?) validator,
//     List<TextInputFormatter>? inputFormatters,
//     TextInputType inputType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: inputType,
//         inputFormatters: inputFormatters,
//         decoration: InputDecoration(
//           labelText: label,
//           suffixIcon: Icon(icon),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
//

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_list_screen.dart';
import 'database/shared_preferences_helper.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final data = await SharedPreferencesHelper.loadProfileData();
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString("profile_image");

    _nameController.text = data['name'] ?? '';
    _emailController.text = data['email'] ?? '';
    _mobileController.text = data['mobile'] ?? '';
    _addressController.text = data['address'] ?? '';

    if (savedImagePath != null && File(savedImagePath).existsSync() && mounted) {
      setState(() {
        _imageFile = File(savedImagePath);
      });
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      await SharedPreferencesHelper.saveProfileData(
        name: _nameController.text,
        email: _emailController.text,
        mobile: _mobileController.text,
        address: _addressController.text,
        imagePath: _imageFile?.path ?? '',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User saved successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CustomerListScreen()),
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", pickedFile.path);
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
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("profile_image");
                if (!mounted) return;
                setState(() => _imageFile = null);
              },
            ),
          ],
        ),
      ),
    );
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
      appBar: AppBar(title: const Text('Profile Registration'), centerTitle: true),
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
                      onPressed: () async {
                        _nameController.clear();
                        _emailController.clear();
                        _mobileController.clear();
                        _addressController.clear();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove("profile_image");
                        if (!mounted) return;
                        setState(() => _imageFile = null);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile data cleared")),
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

