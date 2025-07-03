import 'package:flutter/material.dart';
import 'package:mobile_app/citizen/booking_page.dart';
import 'package:mobile_app/citizen/emergency_page.dart';
import 'package:mobile_app/citizen/medical_advices.dart';
import 'package:mobile_app/citizen/notifications_page.dart';
import 'package:mobile_app/citizen/test_appointments.dart';
import 'package:mobile_app/styles.dart';

// to test the home page alone
void main() {
  runApp(const HomePageTest());
}

class HomePageTest extends StatelessWidget {
  const HomePageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        'booking_page': (context) =>
            BookingPage(), // AppointmentTestScreen(), //BookingPage(),
        'emergency_page': (context) => const EmergencyPage(),
        'medical_advices': (context) => const MedicalAdvicesPage(),
        'notifications_page': (context) => const NotificationsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar('الصفحة الرئيسية'),
        drawer: _citizenDrawer(context),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'حبابك والله \nدايرنا نساعدك في شنو؟',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 70),
              Expanded(
                child: _HomeGrid(), // look at the next class
              ),
            ],
          ),
        ),
      ),
    );
  }

  // registrar drawer
  Drawer _citizenDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'قائمة المواطن', // Translated
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // got to the progile page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         CitizenProfilePage(citizen: this.citizen),
              //   ),
              // );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('الإشعارات'), // Translated
          //   onTap: () {
          //     Navigator.pop(context); // Close the drawer
          //     // go to the notifications page
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             RegistrarNotificationsPage(registrar: this.registrar),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
// go to sitting page or edit eidte it to edit the theme here dirctly
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
// add logout logic here
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
              );
            },
          ),
        ],
      ),
    );
  } // _registrarDrawer
}

// This clas contains the 4 cards in the home screen
class _HomeGrid extends StatelessWidget {
  const _HomeGrid(); // const to improve perfomace
  // (stop rebuilding)

  // Static data for better performance
  static const List<Map<String, dynamic>> _featureData = [
    {
      'icon': Icons.domain_add,
      'title': 'أحجز لي',
      'route': 'booking_page',
    },
    {
      'icon': Icons.phone_in_talk,
      'title': 'حالة مستعجلة',
      'route': 'emergency_page',
    },
    {
      'icon': Icons.volunteer_activism,
      'title': 'نصائح طبية',
      'route': 'medical_advices',
    },
    {
      'icon': Icons.notifications_active,
      'title': 'التنبيهات',
      'route': 'notifications_page',
    },
  ];

  // build fun
  @override
  Widget build(BuildContext context) {
    // Fixed layout: Column + Row to maintain exact card positions
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          // First row: 2 cards
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // First card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 0,
                    ),
                  ),
                ),
                // Second card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Second row: 2 cards
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Third card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 2,
                    ),
                  ),
                ),
                // Fourth card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(''),
          ),
        ],
      ),
    );
  } // build fun
} // _HomeGrid

// Wrapper widget to handle navigation for each card
class _FeatureCardWrapper extends StatelessWidget {
  final int index;

  const _FeatureCardWrapper({required this.index});

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      icon: _HomeGrid._featureData[index]['icon'],
      title: _HomeGrid._featureData[index]['title'],
      onTap: () =>
          Navigator.pushNamed(context, _HomeGrid._featureData[index]['route']),
    );
  }
}

// Componnect of the card
class FeatureCard extends StatelessWidget {
  final IconData icon; // icon
  final String title; // title
  final VoidCallback onTap; // function on Tap

  // constructor
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  // build fun
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Colors.grey[50],
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: Colors.lightBlue),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // build fun
} // FeatureCard
