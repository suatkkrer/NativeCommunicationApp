import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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

  static const platform = MethodChannel('com.example.hybridcommunicationapp/channel');

  String receivedData = "No data received";

  Future<void> getDataFromAndroid() async {
    try {
      final String result = await platform.invokeMethod('getData');
      setState(() {
        receivedData = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        receivedData = "Failed to get data: '${e.message}'.";
      });
    }
  }

  Future<void> sendDataToAndroid(String data) async {
    try {
      await Future.wait([
        platform.invokeMethod('openApp'),
        platform.invokeMethod('sendData', {'data': data}),
      ]);
    } on PlatformException catch (e) {
      print("Failed to send data: '${e.message}'.");
    }
  }

  void sendDataExample() {
    sendDataToAndroid("$_counter");
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(receivedData),
            ElevatedButton(
              onPressed: () {
                getDataFromAndroid(); // Trigger the asynchronous call
              },
              child: const Text("Click button to receive data from android"),
            ),
            ElevatedButton(
              onPressed: () {
                sendDataExample(); // Trigger the asynchronous call
              },
              child: const Text("Click button to send data to android"),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
