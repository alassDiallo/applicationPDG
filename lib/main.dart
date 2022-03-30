import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Application PDG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double? long = 0.0;
  double? lati = 0.0;
  String lien = "http://10.156.52.168:3000/";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    rechercherlocalisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.orange,
      //   title: Text(
      //     widget.title,
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Image.asset(
                      'images/auto.gif',
                    ),
                    Image.asset(
                      'images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                Card(
                  color: Colors.orange,
                  child: Container(
                    height: 200,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "Detail voiture",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Matricule : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "77A45",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Marque : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Toyota",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Matric : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "77A45",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Années : ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "2022",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "longititude : ${long}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Expanded(
                          child: Text(
                            "latitude : ${lati}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                        // FlatButton(
                        //     onPressed: rechercherlocalisation,
                        //     child: Text("cliquer moi"))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void rechercherlocalisation() async {
    // print("recherche par localisation");
    // var position = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // var latitude = position.latitude;

    // var longitude = position.longitude;

    var location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionStatus;
    LocationData lieu;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var currentLocation = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    var lat = currentLocation.latitude;
    var lon = currentLocation.longitude;
    String matricule = "TRSFE6HH";
    setState(() {
      lati = lat;
      long = lon;
    });
    var l = '${this.lien}${long}/${lat}/${matricule}';
    Map<String, dynamic> donnees = {
      "lat": lati.toString(),
      "long": long.toString()
    };
    print('--------------------');
    print(donnees);
    print('--------------------');
    var reponse = await http.get(Uri.parse(l));
    print(reponse.body);
    var curl =
        "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json";

    var rep = await http.get(Uri.parse(curl));
    print(rep.body);
    if (rep.statusCode == 200) {
      var r = json.decode(rep.body);
      print(r);
    }
    location.onLocationChanged.listen((LocationData currentLocation) async {
      print("votre position a changer");
      var lat = currentLocation.latitude;
      var lon = currentLocation.longitude;

      // var lien =
      //     'http://10.156.52.168:3000/' + lon.toString() + "/" + lat.toString();
      setState(() {
        lati = lat;
        long = lon;
      });
      var rep = await http.get(Uri.parse(curl));
      print(rep.body);
    });
  }
}
