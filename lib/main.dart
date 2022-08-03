import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
        primarySwatch: Colors.green,    // pierwszy sposobo wprowadzania koloru
        scaffoldBackgroundColor: const Color(0xffffffff),    // drugi sposobo wprowadzania koloru
      ),
      home: const MyHomePage(title: 'MONITOR ZDROWIA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);
  // int _counter = 0;

//void _incrementCounter() {
//   setState(() {
//      _counter++;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: Text(widget.title),
      ),
      body:  PageView(
        controller: controller,
        children: const[
        DetailPage(headline: 'DZISIAJ', daysInPast: 0),
        DetailPage(headline: 'WCZORAJ', daysInPast: 1),
        DetailPage(headline: 'PRZEDWCZORAJ', daysInPast: 2),

      ],)
    );
  }
}


class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.headline, required this.daysInPast}) : super(key: key);

  final String headline;
  final int daysInPast;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0.0, 32.0),
      child: Column(children:  [
        Text(widget.headline, style: const TextStyle(fontSize: 25, color: Colors.green)),
         TrackingElement(color: const Color(0xFF028121), iconData: Icons.directions_run, unit: 'kroków', max: 6000, daysInPast: widget.daysInPast), //DEFAUULT KROKI 10K
         TrackingElement(color: const Color(0xFFFF0808), iconData: Icons.fitness_center, unit: 'minut ćwiczeń', max: 60, daysInPast: widget.daysInPast),//GODZINA CWICZEN ZWIEKSZANEI CO 5 (CZERWONY)
         TrackingElement(color: const Color(0xFF0040FF), iconData: Icons.water_drop, unit: 'ml wody', max: 2000, daysInPast: widget.daysInPast), //WODA 2L NAPOJOW
         TrackingElement(color: const Color(0xFFE5CF09), iconData: Icons.lunch_dining, unit: 'kcal (5 pos.)', max: 3000, daysInPast: widget.daysInPast), //5 POSILKOW
         TrackingElement(color: const Color(0xFF000000), iconData: Icons.local_cafe, unit: 'ml nabiału', max: 500, daysInPast: widget.daysInPast), //2 SZKLANKI YOGURTU MLEKA
         TrackingElement(color: const Color(0xFF000000), iconData: Icons.laptop, unit: 'm nauki', max: 120, daysInPast: widget.daysInPast), // 120 minut nauki
      ],),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class TrackingElement extends StatefulWidget {
  const TrackingElement({Key? key, required this.color, required this.iconData, required this.unit, required this.max, required this.daysInPast,}) : super(key: key);

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;
  final int daysInPast;

  @override
  _TrackingElementState createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  int _counter = 0;
  double _progress = 0;
  var now = DateTime.now();
  String _storageKey ='';

  void _incrementCounter() async {
    setState(() {
    _counter+= 10;
    _progress = _counter / widget.max;
    });
    (await _prefs).setInt(_storageKey, _counter);
}

@override
void initState()  {
  super.initState();

  _storageKey = '${now.year}-${now.month}-${now.day - widget.daysInPast}_${widget.unit}';
}

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _prefs.then( (prefs) {
      setState(() {
        _counter = prefs.getInt(_storageKey) ?? 0;
        _progress = _counter / widget.max;
      });

    });

  }



  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: _incrementCounter,
      child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 0.0, 20),
          child: Row(children:  <Widget>[
            Icon(widget.iconData, color: Colors.black, size: 50,),
            Text(
                '$_counter / ${widget.max.toInt()} ${widget.unit}',
                 style: const TextStyle(color: Colors.grey, fontSize: 25),
            ),
          ] ),
        ),
         LinearProgressIndicator(
          value: _progress,
          color: widget.color,
          backgroundColor: const Color(0xFFf5f5f5),
          minHeight: 5.0,
        )
      ],
    ),);
  }
}
