import 'package:flutter/material.dart';
import 'booking_page.dart';
import 'emergency_page.dart';
import 'medical_advices.dart';
import 'notifications_page.dart';
import 'styles.dart';

// to test the home page alone
void main() {
  runApp(HomePageTest());
}

class HomePageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        'booking_page': (context) => BookingPage(),
        'emergency_page': (context) => EmergencyPage(),
        'medical_advices': (context) => MedicalAdvicesPage(),
        'notifications_page': (context) => NotificationsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar('الصفحة الرئيسية'),
        drawer: Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    FeatureCard(
                      icon: Icons.domain_add,
                      title: 'أحجز لي',
                      onTap: () {
                        Navigator.pushNamed(context, 'booking_page');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.phone_in_talk,
                      title: 'حالة مستعجلة',
                      onTap: () {
                        Navigator.pushNamed(context, 'emergency_page');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.volunteer_activism,
                      title: 'نصائح طبية',
                      onTap: () {
                        Navigator.pushNamed(context, 'medical_advices');
                      },
                    ),
                    FeatureCard(
                      icon: Icons.notifications_active,
                      title: 'التنبيهات',
                      onTap: () {
                        Navigator.pushNamed(context, 'notifications_page');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[50],
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.lightBlue),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
