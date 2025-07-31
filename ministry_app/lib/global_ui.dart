import 'package:flutter/material.dart';

// Date Selector in reports page and notifications page

Widget buildDateRangeSelector({
  required BuildContext context,
  String hint = "اختر الفترة",
  required DateTimeRange? selectedRange,
  required ValueChanged<DateTimeRange?> onRangeSelected,
}) {
  return Directionality(
    textDirection: TextDirection.rtl, // Arabic layout direction
    child: InkWell(
      onTap: () async {
        DateTimeRange? pickedRange = await showDateRangePicker(
          context: context,
          initialDateRange: selectedRange,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          helpText: 'اختر الفترة',
          cancelText: 'إلغاء',
          confirmText: 'تم',
          saveText: 'حفظ',
          fieldStartHintText: 'من متين؟',
          fieldStartLabelText: 'تاريخ البداية',
          fieldEndHintText: 'لحد متين؟',
          fieldEndLabelText: 'تاريخ النهاية',
            errorInvalidText : 'خطأ!',
            errorFormatText: 'الصيغة دي ما صح',
            errorInvalidRangeText: 'حصلت مشكلة، كدي اتأكد لو عكست تاريخ البداية والنهاية',

          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );

        if (pickedRange != null) {
          onRangeSelected(pickedRange);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedRange != null
                  ? '${selectedRange.start.year}/${selectedRange.start.month}/${selectedRange.start.day} '
                  '- ${selectedRange.end.year}/${selectedRange.end.month}/${selectedRange.end.day}'
                  : hint,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
          ],
        ),
      ),
    ),
  );
}

// Dropdown filter in each of notifications (send/receive) and report pages
Widget buildFilterDropdown({
  required String hint,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Colors.black54,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

Widget buildLabel(String text) {
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





