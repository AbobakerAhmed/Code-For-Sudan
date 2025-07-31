import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:ministry_app/Backend/global_var.dart';
import 'package:ministry_app/Backend/ministry_employee.dart';
import 'package:ministry_app/firestore_services/firedart.dart';
import 'package:ministry_app/global_ui.dart';

/**
    Issues:
    //1- idetify hospital class
    2- link with database to upload the new hospital
    3- edit depatments field, make it a list of check boxes
    4- after creating a hospital successfully, clear all fields and show the adding is done successfuly
    4- hospital manager logic?
 */

class AddingHospitalsScreen extends StatefulWidget {
  final MinistryEmployee employee;
  const AddingHospitalsScreen({super.key, required this.employee});

  @override
  State<AddingHospitalsScreen> createState() =>
      _AddingHospitalsScreenState(employee: employee);
}

class _AddingHospitalsScreenState extends State<AddingHospitalsScreen> {
  _AddingHospitalsScreenState({required this.employee});
  late final MinistryEmployee employee;
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalManagerNameController =
      TextEditingController();
  final TextEditingController _hospitalManagerPhoneController =
      TextEditingController();
  final TextEditingController _hospitalEmergencyPhoneController =
      TextEditingController();
  // Add these variables for dropdowns
  late String _selectedState = employee.getState();
  late String _selectedLocality = employee.getLocality();

  // Firestore service and data holders
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, List<String>> _statesAndLocalities = {};
  List<String> _allDepartments = [];
  Map<String, List<String>> _departmentsAndDoctors = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _hospitalManagerNameController.dispose();
    _hospitalManagerPhoneController.dispose();
    _hospitalEmergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    _isLoading = true;
    // Hardcoded list of common hospital departments in Arabic
    final List<String> hardcodedDepartments = [
      'الطوارئ',
      'الباطنية',
      'الجراحة العامة',
      'الأطفال',
      'النساء والتوليد',
      'العظام',
      'القلب',
      'العيون',
      'الجلدية',
      'الأنف والأذن والحنجرة',
      'المسالك البولية',
      'الأعصاب',
      'النفسية',
      'المختبر',
      'الأشعة',
    ];
    try {
      final statesData = await _firestoreService.getStatesAndLocalities();

      if (mounted) {
        setState(() {
          _statesAndLocalities = statesData;
          _allDepartments = hardcodedDepartments;

          // If the employee is a super-admin ("الكل"), default to the first available state.
          if (employee.getState() == "الكل" &&
              _statesAndLocalities.isNotEmpty) {
            _selectedState = _statesAndLocalities.keys.first;
          }

          // Set the initial locality. If the employee can see all localities,
          // default to the first one for the selected state.
          final localitiesForState = _statesAndLocalities[_selectedState] ?? [];
          if (employee.getLocality() == "الكل" &&
              localitiesForState.isNotEmpty) {
            _selectedLocality = localitiesForState.first;
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching initial data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load states and localities.'),
          ),
        );
      }
    }
  }

  void _showAddDepartmentDialog() {
    String? selectedDepartment;
    final customDepartmentController = TextEditingController();
    final doctorsController = TextEditingController();
    bool isAddingCustom = false;
    // State for validation errors within the dialog
    String? departmentError;
    String? doctorsError;

    // Filter out departments that have already been added to not show them in the dropdown
    final availableDepartments = _allDepartments
        .where((dept) => !_departmentsAndDoctors.containsKey(dept))
        .toList();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isAddingCustom ? 'إضافة قسم مخصص' : 'إضافة قسم وأطباء',
                textDirection: TextDirection.rtl,
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAddingCustom)
                      _buildTextField(
                        controller: customDepartmentController,
                        hintText: 'اسم القسم المخصص...',
                        errorText: departmentError,
                      )
                    else
                      // buildFilterDropdown doesn't support error text, so we wrap it
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFilterDropdown(
                            hint: 'اختر القسم...',
                            value: selectedDepartment,
                            items: availableDepartments,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedDepartment = value;
                                // Clear error when user selects an item
                                if (value != null) {
                                  departmentError = null;
                                }
                              });
                            },
                          ),
                          if (departmentError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, right: 12),
                              child: Text(
                                departmentError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: doctorsController,
                      hintText: 'أسماء الأطباء (افصل بينهم بفاصلة)',
                      errorText: doctorsError,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          isAddingCustom = !isAddingCustom;
                        });
                      },
                      child: Text(
                        isAddingCustom
                            ? 'الاختيار من القائمة'
                            : 'إضافة قسم غير موجود بالقائمة',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final departmentName = isAddingCustom
                        ? customDepartmentController.text.trim()
                        : selectedDepartment;
                    final bool isDepartmentValid =
                        departmentName != null && departmentName.isNotEmpty;
                    final bool areDoctorsValid = doctorsController.text
                        .trim()
                        .isNotEmpty;

                    // If valid, add and close. Otherwise, show errors.
                    if (isDepartmentValid && areDoctorsValid) {
                      final doctors = doctorsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                      setState(() {
                        _departmentsAndDoctors[departmentName!] = doctors;
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Update state to show validation messages
                      setDialogState(() {
                        departmentError = isDepartmentValid
                            ? null
                            : 'الرجاء اختيار أو إدخال اسم القسم.';
                        doctorsError = areDoctorsValid
                            ? null
                            : 'الرجاء إدخال أسماء الأطباء.';
                      });
                    }
                  },
                  child: const Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _hospitalNameController.clear();
      _hospitalManagerNameController.clear();
      _hospitalManagerPhoneController.clear();
      _hospitalEmergencyPhoneController.clear();
      _departmentsAndDoctors.clear();
    });
  }

  Future<void> _addHospital() async {
    final hospitalName = _hospitalNameController.text.trim();
    final emergencyPhone = _hospitalEmergencyPhoneController.text.trim();
    final managerName = _hospitalManagerNameController.text.trim();
    final managerPhone = _hospitalManagerPhoneController.text.trim();

    // 1. Basic validation
    if (hospitalName.isEmpty) {
      _showSnackBar('الرجاء إدخال اسم المستشفى.', isError: true);
      return;
    }
    if (emergencyPhone.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم طوارئ المستشفى.', isError: true);
      return;
    }
    if (_departmentsAndDoctors.isEmpty) {
      _showSnackBar('الرجاء إضافة قسم واحد على الأقل للمستشفى.', isError: true);
      return;
    }
    if (managerName.isEmpty) {
      _showSnackBar('الرجاء إدخال اسم مدير المستشفى.', isError: true);
      return;
    }
    if (managerPhone.isEmpty) {
      _showSnackBar('الرجاء إدخال رقم هاتف مدير المستشفى.', isError: true);
      return;
    }

    // 2. Name format validation
    if (!hospitalName.startsWith('مستشفى')) {
      _showSnackBar('يجب أن يبدأ اسم المستشفى بكلمة "مستشفى".', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 3. Duplicate name validation
      final existingHospitals = await _firestoreService.getHospitalNames(
        _selectedState,
        _selectedLocality,
      );
      if (existingHospitals.any((name) => name.trim() == hospitalName)) {
        _showSnackBar(
          'يوجد مستشفى بهذا الاسم بالفعل في هذه المحلية.',
          isError: true,
        );
        return;
      }

      // 4. All validation passed, create the hospital in Firestore
      await _firestoreService.createHospital(
        state: _selectedState,
        locality: _selectedLocality,
        hospitalName: hospitalName,

        emergencyPhone: emergencyPhone,
        departments: _departmentsAndDoctors,
      );

      _showSnackBar('تمت إضافة المستشفى بنجاح!');
      _resetForm();
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء إضافة المستشفى.', isError: true);
      print("Error during hospital validation: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
              context,
            ); // Go back to the previous screen (Dashboard)
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إضافة مستشفى', // Add Hospital (Arabic)
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.add_circle,
              color: Colors.blue,
              size: 28,
            ), // Add Hospital icon
            SizedBox(width: 8),
          ],
        ),
        titleSpacing: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.lightBlue),
                  SizedBox(height: 30),
                  Text("كيف حالك"),
                ],
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align labels to the right
                  children: [
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    // Hospital Data Section
                    const Text(
                      'بيانات المستشفى', // Hospital Data (Arabic)
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    // Hospital Name
                    buildLabel('اسم المستشفى'), // Hospital Name (Arabic)
                    _buildTextField(
                      controller: _hospitalNameController,
                      hintText: 'اسم مستشفى...', // Hospital name...
                    ),
                    const SizedBox(height: 16),
                    buildLabel('رقم طوارئ المستشفى'),
                    _buildTextField(
                      controller: _hospitalEmergencyPhoneController,
                      hintText: '0123456789',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // State
                        buildLabel('الولاية:'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildFilterDropdown(
                            hint: 'الولاية...', // State...
                            value: _selectedState,
                            items: employee.getState() == "الكل"
                                ? _statesAndLocalities.keys.toList()
                                : [employee.getState()],
                            onChanged: (String? newValue) {
                              if (newValue != null &&
                                  newValue != _selectedState) {
                                setState(() {
                                  _selectedState = newValue;
                                  // When state changes, reset locality to the first in the new list
                                  if (employee.getLocality() == "الكل") {
                                    final localities =
                                        _statesAndLocalities[newValue] ?? [];
                                    _selectedLocality = localities.isNotEmpty
                                        ? localities.first
                                        : '';
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Locality dropdown
                        buildLabel('المحلية:'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: buildFilterDropdown(
                            hint: 'المحلية...', // Locality...
                            value: _selectedLocality,
                            items: employee.getLocality() == "الكل"
                                ? (_statesAndLocalities[_selectedState] ?? [])
                                : [employee.getLocality()],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedLocality = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Hospital Departments
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildLabel('اقسام المستشفى'), // Hospital Departments
                        OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة قسم'),
                          onPressed: _showAddDepartmentDialog,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blueAccent.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 150, // Give it a fixed height to be scrollable
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _departmentsAndDoctors.isEmpty
                          ? const Center(
                              child: Text('لم تتم إضافة أي أقسام بعد'),
                            )
                          : ListView.builder(
                              itemCount: _departmentsAndDoctors.length,
                              itemBuilder: (context, index) {
                                final department = _departmentsAndDoctors.keys
                                    .elementAt(index);
                                final doctors =
                                    _departmentsAndDoctors[department]!;
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      department,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(doctors.join(', ')),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => setState(
                                        () => _departmentsAndDoctors.remove(
                                          department,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'بيانات مدير المستشفى', // Hospital Data (Arabic)
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Hospital Manager Name and Phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildLabel(
                          'الاسم الكامل:',
                        ), // Hospital Manager Name (Arabic)
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _hospitalManagerNameController,
                            hintText: 'محمد أحمد محمد أحمد', // Name...
                          ),
                        ),
                        const SizedBox(width: 16),

                        buildLabel(
                          'رقم الهاتف:',
                        ), // Hospital Manager Phone Number (Arabic)
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _hospitalManagerPhoneController,
                            hintText: '0123456789', // Number...
                            keyboardType: TextInputType.number, // Only numbers
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ], // Only digits
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Send Message Button (Add Hospital Button)
                    SizedBox(
                      width: double.infinity, // Full width button
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _addHospital,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .blueAccent
                              .shade400, // Button background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'إضافة المستشفى', // Add Hospital
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /*
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
*/
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.right, // Align text to the right
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
        ),
      ),
    );
  }
}
