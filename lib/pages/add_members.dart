import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

class Add_Members extends StatefulWidget{
  _Add_Members createState() => _Add_Members();
}

class _Add_Members extends State<Add_Members>{
  QuerySnapshot<Map<String, dynamic>>? searchResultSnapshot;
  QuerySnapshot<Map<String, dynamic>>? Snapshot;
  bool isLoading = false;
  bool haveUserSearched = false;
  bool isChecked = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var searchEditingController = TextEditingController();

  InitiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods.GetUserByUsername(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  GetUsersList() async {
    if (searchEditingController.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods.GetUsers().then((snapShot) {
        Snapshot = snapShot;
        setState(() {
          isLoading = false;
          haveUserSearched = false;
        });
      });
    }
  }

  Widget UserList() {
    return Expanded(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : haveUserSearched
          ? ListView.builder(
          itemCount: searchResultSnapshot?.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              searchResultSnapshot?.docs[index].data()["userName"],
              searchResultSnapshot?.docs[index].data()["userEmail"],
            );
          })
          : ListView.builder(
          itemCount: Snapshot?.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              Snapshot?.docs[index].data()["userName"],
              Snapshot?.docs[index].data()["userEmail"],
            );
          }),
    );
  }

  Widget ListTile(String? userName, String? userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName ?? "",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail ?? "",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          Checkbox(value: isChecked, onChanged: null)
        ],
      ),
    );
  }

  @override
  void initState() {
    GetUsersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  });
            },
          ),
          title: Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                    ),
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: -12.0,
                      blurRadius: 12.0,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: searchEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: GestureDetector(
                        child: GestureDetector(
                          onTap: () {
                            if (searchEditingController.text.isNotEmpty) {
                              InitiateSearch();
                            } else {
                              GetUsersList();
                            }
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: searchEditingController.clear,
                        icon: Icon(
                          Icons.cancel_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ), //Search
              SizedBox(
                height: 12,
              ),
              UserList(),
            ],
          ),
        ));
  }
}
