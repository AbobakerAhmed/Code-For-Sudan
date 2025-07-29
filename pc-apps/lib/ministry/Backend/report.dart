/*
Report class
ClinicalRecord class
ClinicalReport class
EpidemicRecord class
EpidemicReport class
*/

class Report{
  late final String _hospitalState;
  late final String _hospitalLocality;
  late final String _hospitalName;
  late final DateTime _creationTime;
  late final String _type;
  Report(
      this._hospitalState,
      this._hospitalLocality,
      this._hospitalName,
      this._creationTime
      );

  String getState() => this._hospitalState;
  String getLocality() => this._hospitalLocality;
  String getName() => this._hospitalName;
  DateTime getCreationTime() => this._creationTime;

} // Report

class ClinicalRecord{
  /*
  [
   department,
   outpatients,
   admissions,
   discharges,
   inpatientCount,
   totalSurgeries,
   successfulSurgeries,
   failedSurgeries,
   deaths
  ]
*/
  late final String _department;
  late final int _outpatients; // patients those meet the doctor
  late final int _admissions; // patients those be entered/ sleeped in the department
  late final int _discharges; // patients those go outside after stay few days in the department
  late final int _inpatientCount; // current sleeped patients in the department
  late final int _totalSurgeries; // total operations in the department
  late final int _successfulSurgeries;
  late final int _failedSurgeries;
  late final int _deaths; // death cases in the department

   ClinicalRecord(
      this._department,
      this._outpatients,
      this._admissions,
      this._inpatientCount,
      this._discharges,
      this._successfulSurgeries,
      this._failedSurgeries,
      this._deaths
      ){this._totalSurgeries = this._successfulSurgeries + this._failedSurgeries;}

  String getDepartment() =>  this._department;
  int getOutPatients() => this._outpatients;
  int getAdmissions() => this._admissions;
  int getInpatientCount() => this._inpatientCount;
  int getDischarges() =>  this._discharges;
  int getSuccessfulSurgeries() =>  this._successfulSurgeries;
  int getFailedSurgeries() => this._failedSurgeries;
  int getTotalSurgeries() =>  this._totalSurgeries;
  int getDeaths() =>  this._deaths ;

  Map<String, dynamic> toJson() => {
    'department': _department,
    'outpatients': _outpatients,
    'admissions': _admissions,
    'inpatientCount': _inpatientCount,
    'discharges': _discharges,
    'successfulSurgeries': _successfulSurgeries,
    'failedSurgeries': _failedSurgeries,
    'deaths': _deaths,
  };

  factory ClinicalRecord.fromJson(Map<String, dynamic> json) {
    return ClinicalRecord(
      json['department'] as String,
      json['outpatients'] as int,
      json['admissions'] as int,
      json['inpatientCount'] as int,
      json['discharges'] as int,
      json['successfulSurgeries'] as int,
      json['failedSurgeries'] as int,
      json['deaths'] as int,
    );
  }
} //ClinicalRecord

class ClinicalReport extends Report{
  List<ClinicalRecord> _data;

  // Constructor
  ClinicalReport(
      super._hospitalState,
      super._hospitalLocality,
      super._hospitalName,
      super._creationTime,
      this._data
      ){ super._type = "التقارير الدورية";}

  List<ClinicalRecord> getData() => this._data;

  Map<String, dynamic> toJson() => {
    'hospitalState': _hospitalState,
    'hospitalLocality': _hospitalLocality,
    'hospitalName': _hospitalName,
    'creationTime': _creationTime.toIso8601String(),
    'data': _data.map((record) => record.toJson()).toList(),
  };

  factory ClinicalReport.fromJson(Map<String, dynamic> json) => ClinicalReport(
    json['hospitalState'] as String,
    json['hospitalLocality'] as String,
    json['hospitalName'] as String,
    DateTime.parse(json['creationTime'] as String),
    (json['data'] as List<dynamic>)
        .map((e) => ClinicalRecord.fromJson(e as Map<String, dynamic>))
        .toList(),
  );


  // JSON Serialization
} //ClinicalReport

class EpidemicRecord{
  late final String _epidemic;
  late final String _hospitalState;
  late final String _hospitalLocality;
  late final String _hospitalName;

  // Total Patients in the hospital
  late final int _currentPatientsMalesUnder5;
  late final int _currentPatientsFemalesUnder5;
  late final int _currentPatientsMalesAbove5;
  late final int _currentPatientsFemalesAbove5;

  // new cases:
  late final int _newCasesMalesUnder5;
  late final int _newCasesFemalesUnder5;
  late final int _newCasesMalesAbove5;
  late final int _newCasesFemalesAbove5;

  // Death Cases
  late final int _deathCasesMalesUnder5;
  late final int _deathCasesFemalesUnder5;
  late final int _deathCasesMalesAbove5;
  late final int _deathCasesFemalesAbove5;

  EpidemicRecord(
      this._hospitalState,
      this._hospitalLocality,
      this._hospitalName,
      this._epidemic,
      this._currentPatientsMalesUnder5, // male < 5
      this._currentPatientsFemalesUnder5, // female < 5
      this._currentPatientsMalesAbove5, // male > 5
      this._currentPatientsFemalesAbove5, // female > 5

      // new cases
      this._newCasesMalesUnder5, // male < 5
      this._newCasesFemalesUnder5, // female < 5
      this._newCasesMalesAbove5, // male > 5
      this._newCasesFemalesAbove5, // female > 5

      // deaths
      this._deathCasesMalesUnder5, // male < 5
      this._deathCasesFemalesUnder5, // female < 5
      this._deathCasesMalesAbove5, // male > 5
      this._deathCasesFemalesAbove5 // female > 5
      );

  // Getters
  String getEpidemic() => this._epidemic;
  String getState() => this._hospitalState;
  String getLocality() => this._hospitalLocality;
  String getHospital() => this._hospitalName;

  // current patients
  int getCurrentPatientsMaleUnder5() => this._currentPatientsMalesUnder5; // male < 5
  int getCurrentPatientsFemaleUnder5() => this._currentPatientsFemalesUnder5; // female < 5
  int getCurrentPatientsMaleAbove5() => this._currentPatientsMalesAbove5; // male > 5
  int getCurrentPatientsFemaleAbove5() => this._currentPatientsFemalesAbove5; // female > 5

  // new cases
  int getNewCasesMalesUnder5() => this._newCasesMalesUnder5; // male < 5
  int getNewCasesFemalesUnder5() => this._newCasesFemalesUnder5; // female < 5
  int getNewCasesMalesAbove5() => this._newCasesMalesAbove5; // male > 5
  int getNewCasesFemalesAbove5() => this._newCasesFemalesAbove5; // female > 5

  // deaths
  int getDeathCasesMalesUnder5() =>   this._deathCasesMalesUnder5; // male < 5
  int getDeathCasesFemalesUnder5() =>   this._deathCasesFemalesUnder5; // female < 5
  int getDeathCasesMalesAbove5() =>   this._deathCasesMalesAbove5; // male > 5
  int getDeathCasesFemalesAbove5() =>   this._deathCasesFemalesAbove5; // female > 5


  factory EpidemicRecord.fromJson(Map<String, dynamic> json) {
    return EpidemicRecord(
      json['hospitalState'] as String,
      json['hospitalLocality'] as String,
      json['hospitalName'] as String,
      json['epidemic'] as String,
      json['currentPatientsMalesUnder5'] as int,
      json['currentPatientsFemalesUnder5'] as int,
      json['currentPatientsMalesAbove5'] as int,
      json['currentPatientsFemalesAbove5'] as int,
      json['newCasesMalesUnder5'] as int,
      json['newCasesFemalesUnder5'] as int,
      json['newCasesMalesAbove5'] as int,
      json['newCasesFemalesAbove5'] as int,
      json['deathCasesMalesUnder5'] as int,
      json['deathCasesFemalesUnder5'] as int,
      json['deathCasesMalesAbove5'] as int,
      json['deathCasesFemalesAbove5'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'hospitalState': _hospitalState,
    'hospitalLocality': _hospitalLocality,
    'hospitalName': _hospitalName,
    'epidemic': _epidemic,
    'currentPatientsMalesUnder5': _currentPatientsMalesUnder5,
    'currentPatientsFemalesUnder5': _currentPatientsFemalesUnder5,
    'currentPatientsMalesAbove5': _currentPatientsMalesAbove5,
    'currentPatientsFemalesAbove5': _currentPatientsFemalesAbove5,
    'newCasesMalesUnder5': _newCasesMalesUnder5,
    'newCasesFemalesUnder5': _newCasesFemalesUnder5,
    'newCasesMalesAbove5': _newCasesMalesAbove5,
    'newCasesFemalesAbove5': _newCasesFemalesAbove5,
    'deathCasesMalesUnder5': _deathCasesMalesUnder5,
    'deathCasesFemalesUnder5': _deathCasesFemalesUnder5,
    'deathCasesMalesAbove5': _deathCasesMalesAbove5,
    'deathCasesFemalesAbove5': _deathCasesFemalesAbove5,
  };

} // EpidemicRecord

class EpidemicReport extends Report{

  List<EpidemicRecord> _data;

  EpidemicReport(
      super._hospitalState,
      super._hospitalLocality,
      super._hospitalName,
      super._creationTime,
      this._data
      ){ super._type = "تقارير الأوبئة";}

  List<EpidemicRecord> getData() => this._data;

Map<String, dynamic> toJson() => {
'hospitalState': _hospitalState,
'hospitalLocality': _hospitalLocality,
'hospitalName': _hospitalName,
'creationTime': _creationTime.toIso8601String(),
'data': _data.map((record) => record.toJson()).toList(),
};
// JSON Serialization
factory EpidemicReport.fromJson(Map<String, dynamic> json) {
return EpidemicReport(
json['hospitalState'] as String,
json['hospitalLocality'] as String,
json['hospitalName'] as String,
DateTime.parse(json['creationTime'] as String),
(json['data'] as List<dynamic>)
    .map((e) => EpidemicRecord.fromJson(e as Map<String, dynamic>))
    .toList(),
);
}

} // EpidemicReport