import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;
class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}
class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
Future _goToNextScreen(BuildContext context) async {
  Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      }));

  if (results!=null && results.containsKey('enter')){
//    print(results['enter'].toString());
  _cityEntered = results['enter'];
  }
}
  void showstuff() async {
    Map data =await getWeather(util.appID, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: (){_goToNextScreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',width: 490,
              fit:BoxFit.fill,),
            ),
          new Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.fromLTRB(0.0,20.9,20,0.0 ),
              child: new Text('${_cityEntered ==null ? util.defaultCity : _cityEntered}',
                style: cityStyle(),),
            ),
          new Container(
          alignment: Alignment.center,
          child: new Image.asset('images/light_rain.png'),
            ),
          new Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(50, 360, 0, 0),
          child: updateTempWidget(_cityEntered),),
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(240, 560,0,0),
            child: new Text('Made by Ankush',style: TextStyle(color: Colors.white,fontSize: 20,fontStyle: FontStyle.italic),),
          )
        ],
      ),
      );
  }
  Future<Map> getWeather(String appID,String city) async {
    String apiUrl='http://api.openweathermap.org/data/2.5/weather?q=$city,india&APPID='
        '${util.appID}&units=metric';

    http.Response response =await http.get(apiUrl);

    return json.decode(response.body);
  }
  Widget updateTempWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.appID, city ==null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //where we got jsondata
          if (snapshot.hasData) {
             Map content = snapshot.data;
             return new Container(
               child: new Column(
                 children: <Widget>[
                   new ListTile(
                     title: new Text("${content['main']['temp'].toString()}° C" ,style: weatherStyle(),),
                     subtitle: new ListTile(
                       title: new Text(
                         "Humidity: ${content['main']['humidity'].toString()}% \n"
                             "Min: ${content['main']['temp_min'].toString()}° C\n"
                             "Max: ${content['main']['temp_max'].toString()}° C",style: extraWeatherStyle(),
                       ),
                     ),
                   )
                 ],

               ),
             );
          }
        });
  }
}
class ChangeCity extends StatelessWidget {
  var _cityFieldController =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',width: 490,height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
    children: <Widget>[
           new ListTile(
             title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Enter City'),
                controller: _cityFieldController,
                keyboardType: TextInputType.text),
             ),
             new ListTile(
             title: new FlatButton(
                 onPressed:() {
                   Navigator.pop(context, {
                     'enter': _cityFieldController.text
                   });
                 },
                 textColor: Colors.white,
                 color: Colors.blueAccent,
                 child: new Text('Get Weather')),

             )
          ],
       )
    ],
      ),
    );
  }
}
TextStyle cityStyle() {
  return new TextStyle(
      fontSize: 25,
      color: Colors.white,
      fontStyle: FontStyle.italic);
}
TextStyle weatherStyle() {
  return new TextStyle(
      fontSize: 45,

      color: Colors.white,
      fontWeight: FontWeight.w900);
}
TextStyle extraWeatherStyle() {
  return new TextStyle(
      fontSize: 22,
      fontStyle: FontStyle.italic,
      color: Colors.white70,
      fontWeight: FontWeight.w600);
}