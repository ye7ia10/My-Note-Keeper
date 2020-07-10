import 'package:flut/DatabaseHelper.dart';
import 'package:flut/models/Note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class detailsScreen extends StatefulWidget{

  String AppBarTitle;
  Note mynote;

  detailsScreen(this.mynote, this.AppBarTitle);
  @override
  State<StatefulWidget> createState() {
    return detailsScreenState(this.mynote , this.AppBarTitle);
  }

}

class detailsScreenState extends State<detailsScreen>{
  var _Pri = {"Low", "High"};
  var _SelectedItem = "Low";
  String _str = "";

  Note mynote;
  String AppBarTitle;
  detailsScreenState(this.mynote , this.AppBarTitle);
  DatabaseHelper databaseHelper = new DatabaseHelper();

  TextEditingController Tcontroller = TextEditingController();
  TextEditingController Dcontroller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.title;
    Tcontroller.text = mynote.title;
    Dcontroller.text = mynote.description;

    return Scaffold (
      appBar: AppBar(
        title: Text(AppBarTitle),
        leading: IconButton(
          onPressed: (){
              Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            DropdownButton<String>(
              items: _Pri.map((String dropItem) {
                return DropdownMenuItem(
                    value: getPriorityAsString(mynote.priority), child: Text(dropItem));
              }).toList(),
              onChanged: (String newString) {
                setState(() {
                  this._SelectedItem = newString;
                  updatePriorityAsInt(_SelectedItem);
                });
              },
              value: _SelectedItem,
              style: style,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                style: style,
                controller: Tcontroller,
                onChanged: (value){
                  mynote.title = Tcontroller.text;
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: style,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                  style: style,
                  controller: Dcontroller,
                  onChanged: (value){
                    mynote.description = Dcontroller.text;
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: style,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                      )
                  )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("save", style: TextStyle(fontSize: 16.0),),
                      onPressed: (){
                        _save();
                      },
                    ),
                  ),
                  Container(width: 5.0,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text("Delete", style: TextStyle(fontSize: 16.0),),
                      onPressed: (){
                        _delete();
                      },
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        mynote.priority = 1;
        break;
      case 'Low':
        mynote.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = "High";  // 'High'
        break;
      case 2:
        priority = "Low";  // 'Low'
        break;
    }
    return priority;
  }

  // Save data to database
  void _save() async {


    mynote.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (mynote.id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateNote(mynote);
    } else { // Case 2: Insert Operation
      result = await databaseHelper.insertNote(mynote);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {


    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (mynote.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteNote(mynote.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}