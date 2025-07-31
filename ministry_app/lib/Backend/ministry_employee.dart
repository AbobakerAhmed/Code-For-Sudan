/* 
//__________________________Employee Ministry Class__________________________\\
A class that models a hospital Employee including:
  - Name
  - Phone
  - Password
  - state
  - locality
Also contains these functions:
  - getters for each attributer
  - toJson, fromJson those used to database connection
*/

import 'package:flutter/material.dart';
import 'package:ministry_app/Backend/report.dart';
import 'person.dart'; // name, phoneNumber,and password

import 'package:ministry_app/Backend/testing_data.dart'; // will be removed after link

class MinistryEmployee extends Person {
// All name, phoneNumber, and password in person
  final String _state; // in which hospital this employee works
  final String _locality; // in which hospital this employee works
  // Constructor
  MinistryEmployee(super._name, super._phoneNumber, super._password, this._state, this._locality);

  // Getters
  // name, phoneNumber, and password in person
  String getState() => this._state;
  String getLocality() => this._locality;

  String asSender() {
    String result = "${super.getName()}، مشرف وزارة الصحة";
    if (_locality == "الكل") {
      result += " العام";
      if (_state == "الكل") {
        return result;
      }
      result += " بولاية ${_state}";
    }

    result += " بولاية ${_state}، بمحلية ${_locality}";
    return result;
  }

//  void addDeprtment(String name, List<String> doctors) {} // addDepartment
//  void removeDepartment(String department){}

  // For Database Services
  // this function for database link to obtain epidemic reports depending on selected state, locality and hospital
  EpidemicReport fetchEpidemicReport(
      String state, String locality, String hospital, DateTimeRange dateRange) {
    // link database here and assign the obtained value to the next list
    List<EpidemicReport> fetchedReports =
        testingEpidemicReports; // replace it with the list coming form Database
    // get the list of EpidemicReport report here

    if (fetchedReports.isEmpty) {
      throw ArgumentError("The list of reports cannot be empty.");
    }
    // We'll assume the hospital details (state, locality, name) and type are consistent,

    // This map will hold the merged EpidemicRecord objects, keyed by epidemic name for easy lookup.
    final Map<String, EpidemicRecord> mergedRecordsMap = {};

    // Calculate Report Values
    for (final EpidemicReport report in fetchedReports) {
      for (final EpidemicRecord record in report.getData()) {
        final String epidemicName = record.getEpidemic();

        // If an entry for this epidemic already exists, sum the attributes
        if (mergedRecordsMap.containsKey(epidemicName)) {
          final EpidemicRecord existingRecord =
              mergedRecordsMap[epidemicName]!; // obtain values of the existingRecord

          final int newCurrentPatientsMalesUnder5 =
              existingRecord.getCurrentPatientsMaleUnder5() + record.getCurrentPatientsMaleUnder5();
          final int newCurrentPatientsFemalesUnder5 =
              existingRecord.getCurrentPatientsFemaleUnder5() +
                  record.getCurrentPatientsFemaleUnder5();
          final int newCurrentPatientsMalesAbove5 =
              existingRecord.getCurrentPatientsMaleAbove5() + record.getCurrentPatientsMaleAbove5();
          final int newCurrentPatientsFemalesAbove5 =
              existingRecord.getCurrentPatientsFemaleAbove5() +
                  record.getCurrentPatientsFemaleAbove5();

          final int newNewCasesMalesUnder5 =
              existingRecord.getNewCasesMalesUnder5() + record.getNewCasesMalesUnder5();
          final int newNewCasesFemalesUnder5 =
              existingRecord.getNewCasesFemalesUnder5() + record.getNewCasesFemalesUnder5();
          final int newNewCasesMalesAbove5 =
              existingRecord.getNewCasesMalesAbove5() + record.getNewCasesMalesAbove5();
          final int newNewCasesFemalesAbove5 =
              existingRecord.getNewCasesFemalesAbove5() + record.getNewCasesFemalesAbove5();

          final int newDeathCasesMalesUnder5 =
              existingRecord.getDeathCasesMalesUnder5() + record.getDeathCasesMalesUnder5();
          final int newDeathCasesFemalesUnder5 =
              existingRecord.getDeathCasesFemalesUnder5() + record.getDeathCasesFemalesUnder5();
          final int newDeathCasesMalesAbove5 =
              existingRecord.getDeathCasesMalesAbove5() + record.getDeathCasesMalesAbove5();
          final int newDeathCasesFemalesAbove5 =
              existingRecord.getDeathCasesFemalesAbove5() + record.getDeathCasesFemalesAbove5();

          // Create a new EpidemicRecord with summed values (Dart objects are immutable by default for final fields)
          mergedRecordsMap[epidemicName] = EpidemicRecord(
            state,
            locality,
            hospital,
            epidemicName,
            newCurrentPatientsMalesUnder5,
            newCurrentPatientsFemalesUnder5,
            newCurrentPatientsMalesAbove5,
            newCurrentPatientsFemalesAbove5,
            newNewCasesMalesUnder5,
            newNewCasesFemalesUnder5,
            newNewCasesMalesAbove5,
            newNewCasesFemalesAbove5,
            newDeathCasesMalesUnder5,
            newDeathCasesFemalesUnder5,
            newDeathCasesMalesAbove5,
            newDeathCasesFemalesAbove5,
          );
        } else {
          // If this epidemic is new, add it directly to the map
          mergedRecordsMap[epidemicName] = record;
        }
      }
    }

    // Convert the map values back to a list of EpidemicRecord
    final List<EpidemicRecord> mergedData = mergedRecordsMap.values.toList();

    // Create the final merged EpidemicReport
    return EpidemicReport(
      state,
      locality,
      hospital,
      DateTime.now(),
      mergedData,
    );
  } // mergeEpidemicReports

  ClinicalReport fetchClinicalReport(
      String state, String locality, String hospital, DateTimeRange dateRange) {
    // link database here and assign the obtained value to the next list
    List<ClinicalReport> fetchedReports =
        testingClinicalReports; // replace it with the list coming form Database
    // get the list of EpidemicReport report here

    if (fetchedReports.isEmpty) {
      throw ArgumentError("The list of reports cannot be empty.");
    }

    // This map will hold the merged ClinicalRecord objects, keyed by department name for easy lookup.
    final Map<String, ClinicalRecord> mergedRecordsMap = {};

    for (final ClinicalReport report in fetchedReports) {
      for (final ClinicalRecord record in report.getData()) {
        final String departmentName = record.getDepartment();

        if (mergedRecordsMap.containsKey(departmentName)) {
          // If an entry for this department already exists, sum the attributes
          final ClinicalRecord existingRecord = mergedRecordsMap[departmentName]!;
          final int newOutpatients = existingRecord.getOutPatients() + record.getOutPatients();
          final int newAdmissions = existingRecord.getAdmissions() + record.getAdmissions();
          final int newInpatientCount =
              existingRecord.getInpatientCount() + record.getInpatientCount();
          final int newDischarges = existingRecord.getDischarges() + record.getDischarges();
          final int newSuccessfulSurgeries =
              existingRecord.getSuccessfulSurgeries() + record.getSuccessfulSurgeries();
          final int newFailedSurgeries =
              existingRecord.getFailedSurgeries() + record.getFailedSurgeries();
          final int newDeaths = existingRecord.getDeaths() + record.getDeaths();

          // Create a new ClinicalRecord with summed values (Dart objects are immutable by default for final fields)
          final ClinicalRecord updatedRecord = ClinicalRecord(
            departmentName,
            newOutpatients,
            newAdmissions,
            newInpatientCount,
            newDischarges,
            newSuccessfulSurgeries,
            newFailedSurgeries,
            newDeaths,
          );
          mergedRecordsMap[departmentName] = updatedRecord;
        } else {
          // If this department is new, add it directly to the map
          mergedRecordsMap[departmentName] = record;
        }
      }
    }

    // Convert the map values back to a list of EpidemicRecord
    final List<ClinicalRecord> mergedData = mergedRecordsMap.values.toList();

    // Create the final merged EpidemicReport
    return ClinicalReport(
      state,
      locality,
      hospital,
      DateTime.now(),
      mergedData,
    );
  } // mergeClinicalReports
// StaffReport fetchStaffReport(String state, String locality, String hospital, DateTimeRange dateRange){}

  // to Json for sending an object to the database
  Map<String, dynamic> toJson() => {
        'name': super.getName(),
        'phoneNumber': super.getPhoneNumber(),
        'password': super.getPassword(),
        'hospitalState': this._state,
        'hospitalLocality': this._locality,
      };

  // from Json to construct an object from the database
  static MinistryEmployee fromJson({required Map<String, dynamic> MinistryEmp}) => MinistryEmployee(
        MinistryEmp['name'] as String, // Corrected key
        MinistryEmp['phoneNumber'] as String,
        MinistryEmp['password'] as String,
        MinistryEmp['state'] as String,
        MinistryEmp['locality'] as String,
      );
} // HospitalEmployee

