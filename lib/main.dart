import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //fetch data from api
  Future<List<User>> _getUsers() async {
    //use this site to generate json data
    //http://www.json-generator.com

    var url = "http://www.json-generator.com/api/json/get/cfBFSXsKuW?indent=2";
    var data = await http.get(url);

    //convert response to json Object
    var jsonData = json.decode(data.body);

    //Store data in User list from JsonData
    List<User> users = [];
    for (var item in jsonData) {
      User user = User(
          item["index"],
          item["about"],
          item["name"],
          item["picture"],
          item["gender"],
          item["age"],
          item["phone"],
          item["address"],
          item["email"]);

      //add data to user object
      users.add(user);
    }
    //return user list
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          //use future builder to get data from async function
          child: FutureBuilder(
            future: _getUsers(), // getUser function
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                //use listview to display data
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].picture),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].email),
                      trailing: Text(snapshot.data[index].phone),
                      onTap: () {
                        //navigate to user details page
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                                  UserDetails(snapshot.data[index]),
                            ));
                      },
                    );
                  },
                );
              } else {
                return Container(
                    child: Center(
                  child: Text("Loading Data..."),
                ));
              }
            },
          ),
        ));
  }
}

// on tap to show user details
class UserDetails extends StatelessWidget {
  final User user;
  UserDetails(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        child: Card(
          child: Column(
            children: [
              Text("Age: " + user.age.toString()),
              Text("About: " + user.about),
              Text("Address: " + user.address),
              Text("Email: " + user.email),
              Text("Phone: " + user.phone),
            ],
          ),
        ),
      ),
    );
  }
}

//User Class

class User {
  final int index;
  final String about;
  final String name;
  final String picture;
  final String gender;
  final int age;
  final String phone;
  final String address;
  final String email;

//Constructor to intitilize
  User(this.index, this.about, this.name, this.picture, this.gender, this.age,
      this.phone, this.address, this.email);
}
