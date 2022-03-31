import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/dbhelper.dart';
import 'addData.dart';
import '../models/item.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item>? itemList;
  List<Map<String, dynamic>> _item = [];
  bool _isLoading = true;
  void _refreshItems() async {
    final data = await dbHelper.select();
    setState(() {
      _item = data;
      _isLoading = false;
    });
  }
  @override
  void initState(){
    super.initState();
    _refreshItems();
  }
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = <Item>[];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                if (item != null) {
                  //Insert ke Database
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item? item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = TextStyle(
      color: const Color(0xFF111111),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              this.itemList![index].name,
              style: textStyle,
            ),
            subtitle: Expanded(child: Text(this.itemList![index].price.toString())),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    onTap: () async {
                      var item = await navigateToEntryForm(
                          context, this.itemList![index]);
                      //edit item
                      if (item != null) {
                        int result = await dbHelper.update(item);
                        if (result > 0) {
                          updateListView();
                        }
                      }
                    },
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () async {
                      //delete item
                      dbHelper.delete(itemList![index].id);
                      updateListView();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //select dari database
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
