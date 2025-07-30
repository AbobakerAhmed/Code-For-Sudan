import 'package:pc_apps/ministry/Backend/notification.dart';
import 'package:pc_apps/ministry/Backend/global_var.dart';
import 'package:pc_apps/ministry/Backend/report.dart';

// Testing data:
//Clinical Report
final List<ClinicalReport> testingClinicalReports = [
  ClinicalReport("القاهرة", "مدينة نصر", "مستشفى الدمرداش", DateTime(2025, 7, 25), [
    ClinicalRecord("أمراض القلب", 120, 50, 30, 45, 20, 2, 3),
    ClinicalRecord("الأعصاب", 90, 35, 20, 30, 15, 5, 1),
  ]),
  ClinicalReport("الجيزة", "الدقي", "مستشفى العجوزة", DateTime(2025, 7, 26), [
    ClinicalRecord("طب الأطفال", 200, 60, 40, 55, 25, 1, 0),
    ClinicalRecord("العظام", 80, 30, 18, 25, 10, 2, 1),
  ]),
  ClinicalReport("الإسكندرية", "سموحة", "مستشفى الإسكندرية العام", DateTime(2025, 7, 24), [
    ClinicalRecord("الطوارئ", 300, 100, 60, 90, 10, 8, 5),
  ]),
  ClinicalReport("أسوان", "وسط البلد", "مستشفى أسوان العام", DateTime(2025, 7, 23), [
    ClinicalRecord("الأنف والأذن", 110, 45, 25, 40, 12, 1, 0),
    ClinicalRecord("الأمراض الجلدية", 90, 20, 15, 18, 2, 0, 0),
  ]),
  ClinicalReport("الأقصر", "البر الشرقي", "مركز الأقصر الطبي", DateTime(2025, 7, 22), [
    ClinicalRecord("الطب النفسي", 60, 10, 8, 9, 0, 0, 0),
    ClinicalRecord("العناية المركزة", 70, 55, 40, 45, 5, 3, 6),
  ]),
  ClinicalReport("المنصورة", "الجامعة", "مستشفى جامعة المنصورة", DateTime(2025, 7, 21), [
    ClinicalRecord("الأورام", 85, 40, 35, 38, 8, 3, 4),
    ClinicalRecord("الكُلى", 40, 20, 18, 19, 1, 1, 1),
  ]),
  ClinicalReport("طنطا", "وسط البلد", "مستشفى طنطا العام", DateTime(2025, 7, 20), [
    ClinicalRecord("الأشعة", 100, 10, 5, 8, 0, 0, 0),
    ClinicalRecord("النساء والتوليد", 90, 65, 45, 60, 30, 0, 1),
  ]),
  ClinicalReport("الإسماعيلية", "السلام", "مستشفى الإسماعيلية العام", DateTime(2025, 7, 19), [
    ClinicalRecord("المسالك البولية", 50, 25, 22, 24, 5, 0, 1),
    ClinicalRecord("الجهاز الهضمي", 60, 30, 28, 27, 4, 1, 2),
    ClinicalRecord("النساء والتوليد", 60, 65, 45, 60, 30, 0, 1),

  ]),
  ClinicalReport("السويس", "الميناء", "مستشفى السويس", DateTime(2025, 7, 18), [
    ClinicalRecord("العناية المركزة", 40, 38, 36, 30, 3, 1, 4),
    ClinicalRecord("الباطنة العامة", 70, 30, 25, 29, 10, 2, 1),
  ]),
  ClinicalReport("الفيوم", "وسط المدينة", "مستشفى الفيوم العام", DateTime(2025, 7, 17), [
    ClinicalRecord("العظام", 75, 35, 32, 34, 9, 1, 2),
    ClinicalRecord("الجراحة العامة", 85, 45, 40, 42, 15, 4, 3),
  ]),
];




//Epidemic Report
final List<EpidemicReport> testingEpidemicReports = [
  EpidemicReport("القاهرة", "مدينة نصر", "مستشفى الدمرداش", DateTime(2025, 7, 25), [
    EpidemicRecord("الاسهال المائي الحاد", "القاهرة", "مدينة نصر", "مستشفى الدمرداش", 10, 8, 12, 14, 5, 3, 6, 7, 1, 0, 2, 1),
  ]),
  EpidemicReport("الجيزة", "المهندسين", "مستشفى الجيزة المركزي", DateTime(2025, 7, 26), [
    EpidemicRecord("الشلل الرخو الحاد", "الجيزة", "المهندسين", "مستشفى الجيزة المركزي", 4, 3, 5, 4, 2, 1, 3, 2, 0, 0, 0, 1),
  ]),
  EpidemicReport("الإسكندرية", "سموحة", "مستشفى الإسكندرية شمال", DateTime(2025, 7, 24), [
    EpidemicRecord("الحصبة/الحصباء", "الإسكندرية", "سموحة", "مستشفى الإسكندرية شمال", 9, 7, 8, 10, 4, 3, 2, 2, 0, 0, 0, 0),
  ]),
  EpidemicReport("أسوان", "السد العالي", "مستشفى أسوان العام", DateTime(2025, 7, 23), [
    EpidemicRecord("التسمم الغذائي الوبائي", "أسوان", "السد العالي", "مستشفى أسوان العام", 3, 2, 4, 5, 1, 2, 2, 1, 0, 0, 0, 0),
  ]),
  EpidemicReport("الأقصر", "الكرنك", "مستشفى الأقصر", DateTime(2025, 7, 22), [
    EpidemicRecord("الكوليرا", "الأقصر", "الكرنك", "مستشفى الأقصر", 6, 5, 7, 6, 2, 1, 2, 3, 0, 1, 1, 0),
  ]),
  EpidemicReport("المنصورة", "الجامعة", "مستشفى المنصورة", DateTime(2025, 7, 21), [
    EpidemicRecord("الحميات النزفية", "المنصورة", "الجامعة", "مستشفى المنصورة", 5, 4, 6, 5, 3, 2, 2, 1, 1, 0, 0, 0),
  ]),
  EpidemicReport("طنطا", "طنطا الجديدة", "مستشفى طنطا", DateTime(2025, 7, 20), [
    EpidemicRecord("التهاب السحايا", "طنطا", "طنطا الجديدة", "مستشفى طنطا", 7, 6, 8, 7, 4, 3, 3, 2, 1, 1, 1, 1),
  ]),
  EpidemicReport("الإسماعيلية", "السلام", "مستشفى الإسماعيلية الطبي", DateTime(2025, 7, 19), [
    EpidemicRecord("التيفويد", "الإسماعيلية", "السلام", "مستشفى الإسماعيلية الطبي", 6, 6, 7, 8, 3, 3, 4, 2, 1, 0, 0, 1),
  ]),
  EpidemicReport("السويس", "الميناء", "مستشفى السويس المينائي", DateTime(2025, 7, 18), [
    EpidemicRecord("الملاريا", "السويس", "الميناء", "مستشفى السويس المينائي", 4, 3, 4, 5, 2, 1, 2, 1, 0, 0, 0, 0),
  ]),
  EpidemicReport("الفيوم", "وسط المدينة", "مستشفى الفيوم العام", DateTime(2025, 7, 17), [
    EpidemicRecord("السعال الديكي", "الفيوم", "وسط المدينة", "مستشفى الفيوم العام", 5, 4, 6, 7, 3, 2, 2, 3, 0, 0, 1, 0),
  ]),
];

List<Notification> testingNotifications = [
  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "بحري",
    sender: "مستشفى بحري التعليمي",
    title: "تقرير دوري",
    massage: "تم إرفاق التقرير اليومي",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(hours: 1)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان",
    title: "بلاغ وبائي",
    massage: "!تم تشخيص محلية أمدرمان بوباء الكوليرا",
    isImportant: true,
    creationTime: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان",
    title: "تشخيص وبائي",
    massage: "تم تشخيص حاله بوباء ${epidemics[0]}",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(hours: 3)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان العسكري",
    title: "تشخيص وبائي",
    massage: "تم تشخيص حاله بوباء ${epidemics[4]}",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(minutes: 30)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان التعليمي",
    title: "تنبيه إداري",
    massage: "تم إرفاق التقرير اليومي",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(hours: 4)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان",
    title: "بلاغ وبائي",
    massage: "!تم تشخيص محلية أمدرمان بوباء الكوليرا",
    isImportant: true,
    creationTime: DateTime.now().subtract(Duration(days: 1)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى الأمهات",
    title: "تشخيص وبائي",
    massage: "تم تشخيص حاله بوباء ${epidemics[10]}",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(minutes: 10)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى البان جديد",
    title: "تنبيه صحي",
    massage: "تم إرفاق التقرير اليومي",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(hours: 6)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى أمدرمان للأطفال",
    title: "بلاغ وبائي",
    massage: "!تم تشخيص محلية أمدرمان بوباء الكوليرا",
    isImportant: true,
    creationTime: DateTime.now().subtract(Duration(days: 2)),
  ),

  Notification(
    receiverState: "الخرطوم",
    receiverLocality: "أمدرمان",
    sender: "مستشفى السلاح الطبي",
    title: "تشخيص وبائي",
    massage: "تم تشخيص حاله بوباء ${epidemics[7]}",
    isImportant: false,
    creationTime: DateTime.now().subtract(Duration(hours: 5)),
  ),
];
