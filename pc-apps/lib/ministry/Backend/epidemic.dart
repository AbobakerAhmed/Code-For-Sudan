
/*
Issues:
  1- The doctor will send the epidemic notification (early alert) to the ministry
  2- Any epidemic has a Threshold (which is the count of cases before classify a region by that epidemic)
  3- The ministry can send a notification about that epidemic to citizens in a specific region
  4- The hospital manager will send the epidemic report with death cases ....
*/


class Epidemic{
  late final String _name;
  late final int _epidemicThreshold; // how many cases before classify a region by that epidemic
}



