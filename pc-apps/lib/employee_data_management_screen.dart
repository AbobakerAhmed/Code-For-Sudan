import 'package:flutter/material.dart';
import 'package:pc_apps/Backend/hospital.dart';
import 'package:pc_apps/Backend/hospital_employee.dart';
import 'package:pc_apps/Backend/testing_data.dart';
import 'package:pc_apps/global_ui.dart';

/*
Issues:
  1- align columns titles to center
  2- add logic of delete and eidt employee
  3- add logic of adding new employee
 */



class EmployeeDataManagementScreen extends StatefulWidget {
  const EmployeeDataManagementScreen({super.key});

  @override
  State<EmployeeDataManagementScreen> createState() =>
      _EmployeeDataManagementScreenState();
}

class _EmployeeDataManagementScreenState
    extends State<EmployeeDataManagementScreen> {
  String? _selectedJobTitle;
  String? _selectedDepartment;

  final List<String> _jobTitles = [
    'دكتور',
    'ممرض',
    'فني',
  ]; // Doctor, Nurse, Technician
  final List<String> _departments = [
    'العظام',
    'القلب',
    'الاطفال',
  ]; // Orthopedics, Cardiology, Pediatrics

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Transparent to blend with background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align title to the right
          children: [
            Text(
              'إدارة بيانات الموظفين', // Employee Data Management
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // Example font
              ),
              textDirection: TextDirection.rtl, // Right-to-left for Arabic
            ),
            SizedBox(width: 10), // Spacing between text and icon
            Icon(
              Icons.person_pin_outlined, // Placeholder for the custom icon
              color: Colors.deepPurple,
              size: 35,
            ),
            SizedBox(width: 10), // Spacing between text and icon
          ],
        ),
        titleSpacing: 0, // Remove default title spacing
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(
                height: 1,
                color: Colors.grey,
              ), // Thin horizontal line below app bar
              const SizedBox(height: 30),

              // Job Title Dropdown
              Row(children: [
                buildLabel("الوظيفة:"),
                SizedBox(width: 8,),
                buildFilterDropdown(
                    hint: "الكل",
                    value: _selectedJobTitle,
                    items: _jobTitles,
                    onChanged: (newValue){
                      setState((){
                        _selectedJobTitle = newValue;
                      });
                    }
                ),
              ],),
              const SizedBox(height: 20),
              // Department Dropdown
              Row(
                children: [
                  buildLabel("القسم:"),
                  const SizedBox(width: 8),
                  buildFilterDropdown(
                      hint: "الكل",
                      value: _selectedDepartment,
                      items: _departments,
                      onChanged: (newValue){
                        setState(() {
                          _selectedDepartment = newValue;
                        });
                      }
                  ),],
              ),

              const SizedBox(height: 30),

              // Current Employees List Title
              Text(
                'قائمة الموظفين الحاليين', // List of Current Employees
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Cairo',
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),

              _dataTable(),

              SizedBox(height: 20,),
              // Add Employee Button
              ElevatedButton.icon(
                onPressed: () {
                  print('Add Employee tapped');
                  // TODO: Implement add employee logic/navigation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                  foregroundColor: Colors.deepPurple, // Icon and text color
                  minimumSize: const Size(
                    double.infinity,
                    60,
                  ), // Full width, fixed height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  elevation: 2, // Slight shadow
                ),
                icon: const Icon(
                  Icons.person_add, // Person with plus icon
                  size: 30,
                ),
                label: const Text(
                  'اضافة موظف', // Add Employee
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }


  _dataTable(){
    return Expanded(child: SingleChildScrollView(
      child: DataTable(
        border: TableBorder.all(),

          columns: [
            DataColumn(
              label: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8,),
                    Text("الاسم")
                  ],
                ),
              ),
            ),
            DataColumn(label: Center(child: Text("الوظيفة"))),
            DataColumn( label: Center(child: Text("القسم")) ),
            DataColumn( label: Center(child: Text("رقم الهاتف")) ),
            DataColumn( label: Center(child: Text("")) ),
            DataColumn( label: Center(child: Text("")) ),    ],
          rows: _dataRows()
      ),
    ));
  }

  List<DataRow> _dataRows(){
    List<HospitalEmployee> _workersList = testingEmployeers;
    List<DataRow> rows = [];
    for(int i = 0; i < _workersList.length; i++)
      rows.add(_dataRow(_workersList[i]));
    return rows;
  }

  _dataRow(HospitalEmployee employee){
    return DataRow(cells: [
      DataCell(Center(child: Text(employee.getName()))),
      DataCell(Center(child: Text("Rule?"))),
      DataCell(Center(child: Text("department"))),
      DataCell(Center(child: Text(employee.getPhoneNumber()))),

      DataCell(Center(child: SizedBox(
        width: 80, // Fixed width for consistency
        height: 35,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement edit logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Blue for Edit
            padding:
            EdgeInsets.zero, // Remove default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'تعديل', // Edit
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ))),
      DataCell(Center(child: SizedBox(
    width: 100, // Fixed width for consistency
    height: 35,
    child: ElevatedButton(
    onPressed: () {
    // TODO: Implement delete logic
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red, // Red for Delete
    padding:
    EdgeInsets.zero, // Remove default padding
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: const Text(
    'حذف الموظف', // Delete Employee
    style: TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: 'Cairo',
    ),
    textDirection: TextDirection.rtl,
    ),
    ),
    ),)),
    ]);
  }
}


