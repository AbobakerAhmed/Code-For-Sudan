import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registrar_app/citizen/backend/citizen.dart';
import 'package:registrar_app/citizen/backend/citizens_data.dart';
import 'package:registrar_app/citizen/booking_page.dart';
import 'package:registrar_app/citizen/citizen_profile_page.dart';
import 'package:registrar_app/citizen/emergency_page.dart';
import 'package:registrar_app/citizen/medical_advices.dart';
import 'package:registrar_app/citizen/notifications_page.dart';
import 'package:registrar_app/citizen/test_appointments.dart';
import 'package:registrar_app/styles.dart';
import 'package:registrar_app/theme_provider.dart';

// to test the home page alone
void main() {
  runApp(HomePageTest());
}

bool _isDark = false;

class HomePageTest extends StatelessWidget {
  HomePageTest({super.key});
  Citizen citizen = CitizensData.data[
      0]; // default citizen, it does not affcet directly unless when test this page directly

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        citizen: citizen,
      ),
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

class HomePage extends StatefulWidget {
  final Citizen citizen;
  const HomePage({super.key, required this.citizen});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الصفحة الرئيسية"),
        ),
        drawer: _citizenDrawer(context),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'حبابك والله \nدايرنا نساعدك في شنو؟',
                style: Theme.of(context).textTheme.headlineLarge,
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
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'قائمة المواطن', // Translated
              style: Theme.of(context).textTheme.headlineMedium,
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
              //Navigator.pop(context); // Close the drawer
              // got to the progile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CitizenProfilePage(citizen: this.widget.citizen),
                ),
              );
            },
          ),
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            title: Row(
              children: [
                const Icon(Icons.dark_mode),
                SizedBox(
                  width: 16,
                ),
                const Text("الوضع الليلي"),
              ],
            ),
            value: _isDark,
            onChanged: (val) {
              _isDark = val;
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              //setState(() {});
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
  }
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
        color: Theme.of(context).cardColor,
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // build fun
} // FeatureCard
