// import basic ui components
import 'package:flutter/material.dart';

// import pages
import 'package:mobile_app/citizen/booking_page.dart';
import 'package:mobile_app/citizen/medical_history_page.dart';
import 'package:mobile_app/login_page.dart';
import 'package:mobile_app/citizen/notifications_page.dart';
import 'package:mobile_app/backend/citizen/citizen.dart';
import 'package:mobile_app/citizen/citizen_profile_page.dart';

// import backend files
import 'package:provider/provider.dart';
import 'package:mobile_app/theme_provider.dart';

// base class
class HomePage extends StatefulWidget {
  final Citizen? citizen;
  const HomePage({super.key, this.citizen});

  @override
  State<HomePage> createState() => _HomePageState();
}

// class
class _HomePageState extends State<HomePage> {
  bool _isDark = isDark();

  // build the app
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
                child: _HomeGrid(widget.citizen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // custom citizen drawer
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

          // home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),

          // profile
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('الملف الشخصي'), // Translated
            onTap: () {
              if (widget.citizen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CitizenProfilePage(citizen: widget.citizen!),
                  ),
                );
              } else {
                Navigator.pop(context); // Close the drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء تسجيل الدخول أولاً')),
                );
              }
            },
          ),

          // medical history
          ListTile(
            leading: const Icon(Icons.sticky_note_2),
            title: const Text('السجل المرضي'), // Translated
            onTap: () {
              if (widget.citizen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicalHistoryPage(citizen: widget.citizen!),
                  ),
                );
              } else {
                Navigator.pop(context); // Close the drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء تسجيل الدخول أولاً')),
                );
              }
            },
          ),

          // dark/light mode
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
            },
          ),
          const Divider(),

          // log out
          if (widget.citizen != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
                );
              },
            ),
          if (widget.citizen == null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الدخول'), // Translated
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// custom widget
class _HomeGrid extends StatelessWidget {
  final Citizen? citizen;
  const _HomeGrid(this.citizen); // Accept nullable citizen

  List<Map<String, dynamic>> getFeatureData() {
    return [
      {
        'icon': Icons.domain_add,
        'title': 'أحجز لي',
        if (citizen != null) 'route': 'booking_page',
        'page': BookingPage(citizen: citizen),
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
        if (citizen != null) 'route': 'notifications_page',
        'page': NotificationsPage(citizen: citizen),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final featureData = getFeatureData();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // First row: 2 cards
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 0,
                      data: featureData[0],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 1,
                      data: featureData[1],
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 2,
                      data: featureData[2],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _FeatureCardWrapper(
                      index: 3,
                      data: featureData[3],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 2, child: Text('')),
        ],
      ),
    );
  }
}

// custom widget Componnents of the card
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
                Icon(icon, size: 40, color: Theme.of(context).primaryColor),
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

// custom widget
class _FeatureCardWrapper extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;

  // constructor
  const _FeatureCardWrapper({
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      icon: data['icon'],
      title: data['title'],
      onTap: () {
        if (data.containsKey('route')) {
          if (data['route'] == 'booking_page' ||
              data['route'] == 'notifications_page') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => data['page']),
            );
          } else {
            Navigator.pushNamed(context, data['route']);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء تسجيل الدخول اولاً')),
          );
        }
      },
    );
  }
}
