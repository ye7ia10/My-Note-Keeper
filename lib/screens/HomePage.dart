import 'package:flut/DatabaseHelper.dart';
import 'package:flut/models/Note.dart';
import 'package:flut/screens/Details.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class homeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return homeScreenState();
  }

}

class homeScreenState extends State<homeScreen>{
  int _count = 0;
  int counter = 0;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> list;
  @override
  Widget build(BuildContext context) {
    if (list == null) {
      list = List<Note>();
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool res = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return detailsScreen(Note("", "", 2),"Add Note");
            }));
            if(res){
              updateListView();
            }
          },
          child: Icon(Icons.add),
        ),
        body:  getNoteList(),
    );
  }

  ListView getNoteList() {
    return ListView.builder(
        itemCount: _count,
        itemBuilder: (BuildContext context, int pos){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:  getPriorityColor(this.list[pos].priority),
                child: getPriorityIcon(this.list[pos].priority),
              ),
              title: Text(this.list[pos].title),
              subtitle: Text(this.list[pos].date),
              trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey,),
                  onTap: () {
                    _delete(context, list[pos]);
                  },
              ),
              onTap: ()async{
                bool res = await Navigator.push(context, MaterialPageRoute(builder: (context){
                  return detailsScreen(this.list[pos] , "Edit Note");
                }));
                if (res){
                  updateListView();
                }
              },
            ),
          );
        }
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      updateListView();
      _showSnackBar(context, 'Note Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.list = noteList;
          this.counter = noteList.length;
        });
      });
    });
  }

}