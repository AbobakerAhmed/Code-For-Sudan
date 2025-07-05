import 'package:flutter/material.dart';
import 'package:mobile_app/regist/registrar_booked_page.dart';
import 'package:mobile_app/regist/registrar_notification_page.dart';
import 'package:mobile_app/regist/registrar_profile_page.dart';
import 'package:mobile_app/styles.dart';
import 'package:mobile_app/backend/registrar/registrar.dart';

// void main(List<String> args) {
//   // Registrar registrar = Registrar("omar", "0128599405", "1234@Registrar",
//   //     "al-sanousy", 'الجزيرة', 'ود مدني', ["dentsit", "brain"]);
//   runApp(RegistrarHomePageTest(registrar: registrar));
// }

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
//      routes: {      }, // no routes here because we will send registrar object to the next page
    );
  }
}

// registrar home page
class RegistrarHomePage extends StatefulWidget {
  final Registrar registrar; // this page will be only for registrars
  const RegistrarHomePage({super.key, required this.registrar}); // constructor
  @override
  State<StatefulWidget> createState() =>
      _RegistrarHomePageState(registrar: registrar);
} // RegistrarHomePage

// home page content
class _RegistrarHomePageState extends State<RegistrarHomePage> {
  final Registrar registrar; // required
  _RegistrarHomePageState({required this.registrar}); // constructor

  // build fun
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar('الصفحة الرئيسية'),
        drawer: _registrarDrawer(context), // look this fun aftre the build fun
//        bottomNavigationBar: _RegistrarHomeBodyNavigatorBar(), // see the comment at the end of this class
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'شنو يااا فرد\nما تشوفونا برساله ترحيبيه للزول دا',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
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

  // registrar drawer
  Drawer _registrarDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'قائمة المسجل', // Translated
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegistrarProfilePage(registrar: registrar),
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
                  builder: (context) =>
                      RegistrarNotificationsPage(registrar: registrar),
                ),
              );
            },
          ),
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

  // registrar cards in the home page
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
                          //                    key:key,
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
                        //                          key: ,
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

//        bottomNavigationBar: _RegistrarHomeBodyNavigatorBar(),
  // registrar home navigator bar
/*
  BottomNavigationBar _RegistrarHomeBodyNavigatorBar() {
    int _selectedIndex = 0; // مؤشر العنصر المحدد في شريط التنقل السفلي

    // it invoked in the bottom par
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية', // Translated
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'المواعيد', // Translated
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'الإشعارات', // Translated
        ),
      ],
      currentIndex: _selectedIndex, // العنصر المحدد حاليا
      selectedItemColor: Colors.blue[800], // لون العنصر المحدد
      unselectedItemColor: Colors.grey, // لون العناصر غير المحددة
      onTap: _onItemTapped, // الدالة التي تُستدعى عند النقر
    );
  } //
*/
} // registrar home page

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
        color: Colors.grey[50],
        child: InkWell(
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
