import 'package:flutter/material.dart';
import 'package:flutter_notebook_sqllite/model/Note.dart';
import 'package:flutter_notebook_sqllite/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_notebook_sqllite/utils/CommanUtils.dart';
import 'package:flutter_notebook_sqllite/utils/StringUtils.dart';

class NoteDetials extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetials(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return NoteDetialsState(this.note, this.appBarTitle);
  }
}

class NoteDetialsState extends State<NoteDetials> {
  CommanUtils _commanUtils;
  static var _priorites = ['High', 'Low'];
  TextEditingController _textEditingControllerTitle = TextEditingController();
  TextEditingController _textEditingControllerDesc = TextEditingController();
  String appBarTitle;
  Note note;
  DatabaseHelper _databaseHelper = new DatabaseHelper();

  NoteDetialsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _commanUtils = new CommanUtils(context);
    TextStyle textStyle = Theme.of(context).textTheme.title;

    _textEditingControllerTitle.text = note.title;
    _textEditingControllerDesc.text = note.descri;
    return WillPopScope(
        onWillPop: () {
          MovetoBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  MovetoBack();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.all(5.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                      items: _priorites.map((String dropdownItem) {
                        return DropdownMenuItem<String>(
                          value: dropdownItem,
                          child: Text(dropdownItem),
                        );
                      }).toList(),
                      value: updatePriorityAsString(note.priority),
                      style: textStyle,
                      onChanged: (valselectedByUser) {
                        setState(() {
                          updatePriorityAsInt(valselectedByUser);
                        });
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: TextField(
                    controller: _textEditingControllerTitle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: StringUtils().strTitle,
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: TextField(
                    controller: _textEditingControllerDesc,
                    maxLines: 10,
                    onChanged: (value) {
                      updateDescri();
                    },
                    decoration: InputDecoration(
                        labelText: StringUtils().strDescription,
                        alignLabelWithHint: true,
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                StringUtils().btnUpdate,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_textEditingControllerTitle
                                      .text.isEmpty) {
                                    _commanUtils
                                        .showToast(StringUtils().toastTitle);
                                  } else if (_textEditingControllerDesc
                                      .text.isEmpty) {
                                    _commanUtils
                                        .showToast(StringUtils().toastDesc);
                                  } else {
                                    _update();
                                  }
                                });
                              })),
                      Container(
                        width: 5.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void MovetoBack() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String updatePriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorites[0];
        break;
      case 2:
        priority = _priorites[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = _textEditingControllerTitle.text;
  }

  void updateDescri() {
    note.descri = _textEditingControllerDesc.text;
  }

  void _update() async {
    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    result = await _databaseHelper.updateNotes(note);

    if (result != 0) {
      MovetoBack();
      _commanUtils.showToast(StringUtils().strSaved);
    } else {
      _commanUtils.showToast(StringUtils().strSaveIssue);
    }
  }
}
