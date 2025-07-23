import 'package:flutter/material.dart';
import 'package:mobile_app/doctor/doctor_booking_page.dart';
import 'package:mobile_app/doctor/doctor_notifications_page.dart';
import 'package:mobile_app/doctor/doctor_profile_page.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';
import 'package:mobile_app/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/backend/doctor/doctor.dart';

class DoctorHomePageTest extends StatelessWidget {
  final Doctor doctor;

  const DoctorHomePageTest({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorHomePage(
        doctor: doctor,
      ),
//      routes: {      }, // no routes here because we will send doctor object to the next page
    );
  }
}

// doctor home page
class DoctorHomePage extends StatefulWidget {
  final Doctor doctor; // this page will be only for doctors
  const DoctorHomePage({super.key, required this.doctor}); // constructor
  @override
  State<StatefulWidget> createState() => _doctorHomePageState(doctor: doctor);
} // doctorHomePage

// home page content
class _doctorHomePageState extends State<DoctorHomePage> {
  final Doctor doctor; // required
  _doctorHomePageState({required this.doctor}); // constructor
  bool _isDark = isDark();

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الصفحة الرئيسية'),
        ),
        drawer: _doctorDrawer(context), // look this fun aftre the build fun
//        bottomNavigationBar: _doctorHomeBodyNavigatorBar(), // see the comment at the end of this class
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                "أهلا وسهلا \n نورتنا يا دكتور",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 70),
              Expanded(
                child: _doctorHomeCards(
                    context), // look at the next class and the function after _doctorDrawer
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

  // doctor drawer
  Drawer _doctorDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'قائمة الدكتور', // Translated
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
              Navigator.pop(context); // Close the drawer
              // got to the progile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorProfilePage(doctor: doctor),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('الإشعارات'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // go to the notifications page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorNotificationsPage(doctor: doctor),
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
  } // _doctorDrawer

  // doctor cards in the home page
  Padding _doctorHomeCards(BuildContext context) {
    // We have only 2 cards here: appointments and notifications
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          // space between welcoming sentence and cards
          Expanded(
            flex: 2,
            child: Text(''),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // 1st card
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: FeatureCard(
                          //                    key:key,
                          icon: Icons.edit_calendar,
                          title: 'سجل الحجوزات',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookedAppointmentsPage(doctor: doctor)));
                        },
                      )),
                ),
                // 2nd card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      child: FeatureCard(
                        //                          key: ,
                        icon: Icons.notifications_active,
                        title: 'التنبيهات',
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DoctorNotificationsPage(doctor: doctor)));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // space between cards and end of the screen
          Expanded(
            flex: 4,
            child: Text(''),
          ),
        ],
      ),
    );
  } // build fun
} // doctor home page

// Componnect of the card
class FeatureCard extends StatelessWidget {
  final IconData icon; // icon
  final String title; // title

  // constructor
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
  });

  // build fun
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Theme.of(context).cardColor,
        child: InkWell(
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
