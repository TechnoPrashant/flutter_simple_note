class Note {
  int _id;
  String _title;
  String _descri;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._descri]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._descri]);

  //Getter

  int get id => _id;

  String get date => _date;

  int get priority => _priority;

  String get descri => _descri;

  String get title => _title;

  set priority(int value) {
    _priority = value;
  }

  //Setter
  set id(int value) {
    _id = value;
  }

  set date(String value) {
    _date = value;
  }

  set descri(String value) {
    _descri = value;
  }

  set title(String value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['date'] = _date;
    map['descri'] = _descri;
    map['priority'] = _priority;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._descri = map['descri'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
