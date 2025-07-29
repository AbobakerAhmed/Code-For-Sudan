class Notification {
  bool isRed = false;
  late final String _reseiverState;
  late final String _reseiverLocality;
  late final String _sender;
  late final String _title;
  late final String _massage;
  late final DateTime _creationTime;
  late final bool isImportant;

  Notification({
    required String receiverState,
    required String receiverLocality,
    required String sender,
    required String title,
    required String massage,
    required isImportant,
    required creationTime,
    isRed
  }){
    this._reseiverState = receiverState;
    this._reseiverLocality = receiverLocality;
    this._sender = sender;
    this._title = title;
    this._massage = massage;
    this.isImportant = isImportant;
    this._creationTime = creationTime;
    isRed ? this.isRed = true : false;
}

  // Getters
  String getTitle() => this._title;
  String getMassage() => this._massage;
  String getSender() => this._sender;
  String getReseveirState() => this._reseiverState;
  String getReseveirLocality() => this._reseiverLocality;
  DateTime getCreationTime() => this._creationTime;
  String timeFormatAMPM() =>
      '${this._creationTime.hour % 12 == 0 ? 12 : this._creationTime.hour % 12}:${this._creationTime.minute.toString().padLeft(2, '0')} ${this._creationTime.hour >= 12 ? 'PM' : 'AM'}';

  setAsRed(){
    isRed = true;
    // go to the notification place in Database and perform this edition in the real notification
  }


} // Notification

/*
  Notification Card
   _____________________________________________
  | Title                                       |
  |_____________________________________________|
  | Massage                                     |
  |                                             |
  |                                             |
  |_____________________________________________|
  | Sender                                      |
  |                                creationTime |
   _____________________________________________

  if important, the card should be red, and the massage should be send as SMS
*/