import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

late Future<users> Users;
String body = '';

abstract class ABI {
  Future<Response> getusers();
}

class JsonPlaceholder implements ABI {
  final String _host = "https://jsonplaceholder.typicode.com/users/1";
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };
  @override
  Future<Response> getusers() async {
    return await get(Uri.parse(_host), headers: headers);
  }
}

class company {
  String name;
  String catchPhrase;
  String bs;
  company({required this.name, required this.bs, required this.catchPhrase});
  factory company.fromjason(Map<String, String> jason) {
    return company(
        name: jason['name'] as String,
        bs: jason['bs'] as String,
        catchPhrase: jason['catchPhrase'] as String);
  }
}

class Geo {
  int lat;
  int lng;
  Geo({required this.lat, required this.lng});
  factory Geo.fromjson(Map<String, int> json) {
    return Geo(lat: json['lat'] as int, lng: json['lng'] as int);
  }
}

class adrdress {
  String street;
  String suite;
  String city;
  int zipcode;
  Map Geo;
  adrdress(
      {required this.street,
      required this.suite,
      required this.city,
      required this.zipcode,
      required this.Geo});
  factory adrdress.fromjson(Map<String, dynamic> json) {
    return adrdress(
        street: json['street'] as String,
        suite: json['suite'] as String,
        city: json['city'] as String,
        zipcode: json['zipcode'] as int,
        Geo: json['geo'] as Map);
  }
}

class users {
  int id;
  String name;
  String username;
  String email;
  Map address;
  String phone;
  String website;
  Map company;

  users(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.address,
      required this.phone,
      required this.website,
      required this.company});
  factory users.fromJson(Map<String, dynamic> json) {
    return users(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        address: json['address'] as Map,
        phone: json['phone'] as String,
        website: json['website'] as String,
        company: json['company']);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<users> getuser() async {
  JsonPlaceholder jsonPlaceholder = JsonPlaceholder();
  Response response = await jsonPlaceholder.getusers();
  if (response.statusCode == 200) {
    body = response.body;
    Map<String, dynamic> map = jsonDecode(body);
    return users.fromJson(map);
  }
  return users(
      id: 0,
      name: '',
      username: '',
      email: '',
      address: {},
      phone: '',
      website: '',
      company: {});
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initstate() {
    Users = getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: Users,
              builder: (context, AsyncSnapshot<users> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasData) {
                      users myuser = snapshot.data!;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(myuser.name),
                          ),
                          Expanded(child: Text(myuser.email)),
                          Expanded(child: Text(myuser.username)),
                          Expanded(child: Text(myuser.website)),
                          Expanded(child: Text(myuser.phone)),
                          Expanded(child: Text(myuser.email)),
                          Expanded(child: Text(myuser.email)),
                        ],
                      );
                    } else {
                      return Text(snapshot.error.toString());
                    }
                }
              })),
    );
  }
}
