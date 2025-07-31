// import basic ui components
import 'package:flutter/material.dart';

// import backend files
import 'package:mobile_app/firestore_services/firestore.dart';

void main(List<String> args) {
  runApp(const MedicalAdvicesTest());
}

class MedicalAdvicesTest extends StatelessWidget {
  const MedicalAdvicesTest({super.key});

  @override
  Widget build(BuildContext) {
    return const Directionality(
        textDirection: TextDirection.rtl, // arabic lang
        child: MaterialApp(home: MedicalAdvicesPage()));
  }
} // MedicalAdvicesTest

// base class
class MedicalAdvicesPage extends StatefulWidget {
  const MedicalAdvicesPage({super.key});

  @override
  _MedicalAdvicesPageState createState() => _MedicalAdvicesPageState();
}

// class
class _MedicalAdvicesPageState extends State<MedicalAdvicesPage> {
  final FirestoreService _firestoreService =
      FirestoreService(); // define the database objcet

  // define variables
  bool _isLoading = false;
  List<String> advices = [];
  int currentIndex = 0;

  /// fun: show the next advice
  void showNextAdvice() async {
    setState(() {
      currentIndex = (currentIndex + 1) % advices.length;
    });
  }

  /// fun: display adive
  void fetchAndDisplayAdvices() async {
    setState(() {
      _isLoading = true;
    });
    try {
      advices = await _firestoreService.getMedicalAdvices();
      advices.shuffle();
    } catch (e) {
      print("Error while fetching advices: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // initialize the widget state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndDisplayAdvices();
  }

  // build the app
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("النصائح الطبية"),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 30,
                    ),
                    Text("كيف حالك"),
                  ],
                ),
              )
            : advices.isEmpty
                ? Center(
                    child: Text("لا توجد نصائح"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          color: Theme.of(context).primaryColorLight,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              advices[currentIndex],
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.6,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: showNextAdvice,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: Text(
                              'التالي',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      ),
    );
  }
}
