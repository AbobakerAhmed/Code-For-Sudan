import 'package:flutter/material.dart';
import 'package:mobile_app/styles.dart';
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

class MedicalAdvicesPage extends StatefulWidget {
  const MedicalAdvicesPage({super.key});

  @override
  _MedicalAdvicesPageState createState() => _MedicalAdvicesPageState();
}

class _MedicalAdvicesPageState extends State<MedicalAdvicesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  List<String> advices = [];
  /*   '💧 اشرب كميات كافية من الماء يوميًا، خاصة في الأجواء الحارة.',
    '🧼 اغسل يديك جيدًا قبل الأكل وبعد استخدام الحمام.',
    '💊 لا تستخدم المضادات الحيوية بدون وصفة طبية.',
    '🏃‍♂️ احرص على ممارسة الرياضة بانتظام للحفاظ على صحتك.',
    '🍏 ابتعد عن الأطعمة الغنية بالدهون والسكريات الزائدة.',
    '🛌 تأكد من أخذ قسط كافٍ من النوم كل ليلة.',
    '🩺 قم بقياس ضغط الدم بانتظام إذا كنت معرضًا  للمشاكل الصحية.',
    '🧪 احرص على فحص السكر من حين لآخر خاصة لو كان في العائلة من يعاني منه.',
    '⚠️ لا تتجاهل الأعراض البسيطة، فقد تكون مؤشرًا لمشكلة أكبر.',
    '🚭 تجنب التدخين تمامًا، فهو مضر بكل أجهزة الجسم.',
    '🥶 تأكد من لبس الأغطية الدافئة في الشتاء.'
  */

  int currentIndex = 0;

  void showNextAdvice() async {
    setState(() {
      currentIndex = (currentIndex + 1) % advices.length;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndDisplayAdvices();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar('النصائح الطبية'),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
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
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              advices[currentIndex],
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
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
                            child: const Text('التالي'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
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
