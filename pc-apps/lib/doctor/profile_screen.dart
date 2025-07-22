import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'الملف الشخصي', // Profile
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.person, color: Colors.blue.shade700, size: 30),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align contents to the right
          children: [
            // Divider line below the app bar content
            const Divider(color: Colors.grey, height: 1, thickness: 0.5),
            const SizedBox(height: 30),

            // Name field
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    readOnly: true, // As per image, it seems read-only
                    controller: TextEditingController(
                      text: 'wael mahadi monis',
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':الاسم', // Name:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Phone Number field
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    readOnly: true, // As per image
                    controller: TextEditingController(text: '+249 123456789'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':رقم الجوال', // Mobile Number:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Password field with Edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle "تعديل" (Edit) action for password
                    print('Edit password tapped');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'تعديل', // Edit
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    obscureText: true,
                    readOnly: true, // As per image
                    controller: TextEditingController(text: '************'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':كلمة المرور', // Password:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Level (المستوى)
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    readOnly: true,
                    controller: TextEditingController(
                      text: 'استشاري',
                    ), // Consultant
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':المستوى', // Level:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hospital (المستشفى) and Department (القسم)
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    readOnly: true,
                    controller: TextEditingController(
                      text: 'العظام',
                    ), // Orthopedics (Bones)
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':القسم', // Department:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    readOnly: true,
                    controller: TextEditingController(
                      text: 'مستشفى الجزيرة',
                    ), // Al Jazeera Hospital
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ':المستشفى', // Hospital:
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
