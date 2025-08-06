// import basic ui components
import 'package:flutter/material.dart';

// import backend files
import 'package:mobile_app/regist/registrar_booked_page.dart';
import 'package:mobile_app/regist/registrar_notification_page.dart';
import 'package:mobile_app/regist/registrar_profile_page.dart';

// import pages
import 'package:mobile_app/backend/registrar/registrar.dart';
import 'package:mobile_app/theme_provider.dart';
import 'package:provider/provider.dart';

// test class
class RegistrarHomePageTest extends StatelessWidget {
  final Registrar registrar;

  const RegistrarHomePageTest({super.key, required this.registrar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrarHomePage(
        registrar: registrar,
      ),
    );
  }
}

// base class
class RegistrarHomePage extends StatefulWidget {
  final Registrar registrar; // this page will be only for registrars
  const RegistrarHomePage({super.key, required this.registrar}); // constructor
  @override
  State<StatefulWidget> createState() =>
      _RegistrarHomePageState(registrar: registrar);
} // RegistrarHomePage

// class
class _RegistrarHomePageState extends State<RegistrarHomePage> {
  final Registrar registrar; // required
  _RegistrarHomePageState({required this.registrar}); // constructor
  bool _isDark = isDark();

  // build the app
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الصفحة الرئيسية'),
        ),
        drawer: _registrarDrawer(context),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                "حبابك ألف \n ربنا يتم العافية",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 70),
              Expanded(
                child: _registrarHomeCards(
                    context), // look at the next class and the function after _registrarDrawer
              ),
            ],
          ),
        ),
      ),
    );
  } // build fun

  // custom widget: registrar drawer
  Drawer _registrarDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'قائمة المسجل', // Translated
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
              Navigator.pop(context); // Close the drawer
              // got to the progile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegistrarProfilePage(registrar: registrar),
                ),
              );
            },
          ),

          // notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('الإشعارات'), // Translated
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // go to the notifications page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegistrarNotificationsPage(registrar: registrar),
                ),
              );
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

  // custom widget: registrar cards in the home page
  Padding _registrarHomeCards(BuildContext context) {
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
                          icon: Icons.edit_calendar,
                          title: 'سجل الحجوزات',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookedAppointmentsPage(
                                      registrar: registrar)));
                        },
                      )),
                ),

                // 2nd card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      child: FeatureCard(
                        icon: Icons.notifications_active,
                        title: 'التنبيهات',
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrarNotificationsPage(
                                        registrar: registrar)));
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
} // registrar home page

// custom widget: Componnect of the card
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
