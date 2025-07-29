/*
+-------------------------------------------------------------+
| Clinical Report – [Hospital Name] – [Date]                 |
| Location: [State], [Locality]                               |
+-------------------------------------------------------------+

[ Card: Emergency ]
- Outpatients: 130
- Admissions: 50
- Inpatients: 35
- Discharges: 20
- Surgeries: 12 (10 ✓ / 2 ✗)
- Deaths: 3

[ Card: Surgery ]
- Outpatients: 85
- Admissions: 40
- Inpatients: 22
- Discharges: 18
- Surgeries: 28 (26 ✓ / 2 ✗)
- Deaths: 0

...

*/


/*
GridView.count(
  crossAxisCount: 2,
  children: clinicalReport.getData().map((record) => Card(
    child: Column(
      children: [
        Text(record.getDepartment(), style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Outpatients: ${record.getOutPatients()}"),
        Text("Admissions: ${record.getAdmissions()}"),
        Text("Inpatients: ${record.getInpatientCount()}"),
        Text("Discharges: ${record.getDischarges()}"),
        Text("Surgeries: ${record.getTotalSurgeries()} "
             "(${record.getSuccessfulSurgeries()} ✓ / ${record.getFailedSurgeries()} ✗)"),
        Text("Deaths: ${record.getDeaths()}"),
      ],
    ),
  )).toList(),
)
*/


/*
Clinical Report - [Hospital Name]

[📊 Pie Chart: Surgeries Success Rate per Department]
[📈 Bar Chart: Outpatients by Department]
[📉 Line Chart: Deaths over time (if historical)]

[ Department Cards or KPIs Below Charts ]
*/
/*
Column(
  children: [
    Text("Clinical Summary - ${clinicalReport.hospitalName}"),
    SizedBox(height: 20),
    PieChart(data: _buildSurgerySuccessData(clinicalReport)),
    BarChart(data: _buildOutpatientBarData(clinicalReport)),
    ...clinicalReport.getData().map((record) => ListTile(
      title: Text(record.getDepartment()),
      subtitle: Text("Inpatients: ${record.getInpatientCount()}, Deaths: ${record.getDeaths()}"),
    )),
  ],
)
 */