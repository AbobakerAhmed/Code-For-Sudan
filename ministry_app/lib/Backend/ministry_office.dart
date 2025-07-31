import 'package:ministry_app/Backend/report.dart';
import 'package:ministry_app/Backend/global_var.dart';

class MinistryOffice{
  late final String _state;
  late final String _locality;
  late Map<String, int> _epidemicsInLocality;
  List<ClinicalReport>? _clinicalReports;
  List<EpidemicReport>? _epidemicReports;

  // Getters
  String getState() => this._state;
  String getLocality() => this._locality;
  List<ClinicalReport>? getClinicalReports() => this._clinicalReports == null ? null : this._clinicalReports!;
  List<EpidemicReport>? getEpidemicReports() => this._epidemicReports == null ? null : this._epidemicReports!;

  // this fun will be used when the doctor diagnose a new epidemic case
  void incrementAnEpidemic(String state, String locality, String epidemic) {
      // 1- get the old No. cases of this epidemic form database (use fromJson or get the specific int only)
      // 2- increment that number be one
      // 3- if the new No. cases of this epidemic > epidemicThresholds[epidemic] // in global variables
          // send a notification to the ministry employee with:
              // a- Locality employee (with the same state and the same locality)
              // b- State employee (with the same state and locality = "الكل")
              // c- Global employee (with state = "الكل")
  }

  // constructor
  MinistryOffice( {
    required state,
    required locality,
    Map<String, int>? epidemics,
    List<ClinicalReport>? clinicalReports,
    List<EpidemicReport>? epidemicReports,
  }
  ){
    this._state = state;
    this._locality = locality;
    this._epidemicsInLocality = epidemics ?? epidemicsAsMap();
    this._clinicalReports = clinicalReports ?? []; // Initialize as empty list if null
    this._epidemicReports = epidemicReports ?? []; // Initialize as empty list if null
  }

/*
      void addClinicalReport(ClinicalReport report){
      if(_reports == null) _reports = [report];
      else this._reports!.add(report);
      }
   */


  Map<String, dynamic> toJson() => {
    'state': _state,
    'locality': _locality,
    'epidemicsInLocality': _epidemicsInLocality,
    // Convert lists of objects to lists of their JSON representations
    'clinicalReports': _clinicalReports?.map((report) => report.toJson()).toList() ?? [],
    'epidemicReports': _epidemicReports?.map((report) => report.toJson()).toList() ?? [],
  };

}