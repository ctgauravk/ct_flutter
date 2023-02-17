import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

GlobalKey globalKey = GlobalKey();

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SDK Integration'),
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
  var inboxInitialized = false;
  late CleverTapPlugin _clevertapPlugin;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;
  String appGroupID = 'group.flutter.fct';

  //for killed state notification clicked
  static const platform = MethodChannel("myChannel");

  Map<String, dynamic> myParams = {
    'email': 'null'
  };
  @override
  void initState() {
    super.initState();

    CleverTapPlugin.setDebugLevel(3);
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.createNotificationChannelGroup("groupId", "groupName");

    SharedPreferenceAppGroup.setAppGroup(appGroupID);

    CleverTapPlugin.createNotificationChannel(
        "euro", "Test Notification Flutter", "Flutter Test", 5, true);
    CleverTapPlugin.createNotificationChannelWithGroupId(
        "gtid1", "Test Notification Flutter", "Flutter Test", 5, "groupId", true);

    CleverTapPlugin.createNotificationChannelWithGroupId(
        "gtid2", "Test Notification Flutter", "Flutter Test", 5, "groupId", true);
    var stuff = ["bags", "shoes"];
    CleverTapPlugin.onUserLogin({
      'Name': 'Test 28',
      'Identity': 'test28',
      'Email': 'test28@test.com',
      'Phone': '+14364532109',
      'MSG-email': true,
      'MSG-push': true,
      'MSG-sms': true,
      'MSG-whatsapp': true,
      'DOB':'23-06-2001'
    });
    SharedPreferenceAppGroup.setString('email', 'test28@test.com');
    getMyParams();

    //For Killed State Handler
    platform.setMethodCallHandler(nativeMethodCallHandler);

    CleverTapPlugin.initializeInbox();
    var initURl = CleverTapPlugin.getInitialUrl();
    print("1111111111111111 $initURl");


  }

  Future<void> getMyParams() async {
     String stringValue = await SharedPreferenceAppGroup.get('email');

    this.myParams = {
      'email': stringValue
    };

    print("111111 from app groups $stringValue");

    String text = '';
    for (String key in this.myParams.keys) {
      text += '$key = ${this.myParams[key]}\n';
      print("11111 inside for loop $text");
    }


  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    this.setState(() {
      print("inApp12345678 called = ${map.toString()}");
    });
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = CleverTapPlugin();

    //Handler for receiving Push Clicked Payload in FG and BG state
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
        pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    _clevertapPlugin
        .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
        inAppNotificationButtonClicked);
  }

  // void inAppNotificationButtonClicked(Map<String, dynamic> map) {
  //   setState(() {
  //     print("inAppNotificationButtonClicked called = ${map.toString()}");
  //   });
  // }

  //For Push Notification Clicked Payload in FG and BG state
  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    debugPrint("pushClickedPayloadReceived called");
    setState(() async {
      var data = jsonEncode(map);
      debugPrint("on Push Click Payload = $data");
    });
  }

  //For Push Notification Clicked Payload in killed state
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    debugPrint("killed state called!");
    switch (methodCall.method) {
      case "onPushNotificationClicked":
        debugPrint("onPushNotificationClicked in dart");
        debugPrint("Clicked Payload in Killed state: ${methodCall.arguments}");
        return "This is from android!!";
      default:
        return "Nothing";
    }
  }

  void inboxDidInitialize() {
    setState(() {
      debugPrint("inboxDidInitialize called");
      inboxInitialized = true;
    });
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    setState(() async {
      List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();
      debugPrint("inboxDidInitialize called");
      debugPrint("Display Units are " + displayUnits.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Profile push"),
                  subtitle: const Text("push your profile"),
                  onTap: login,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Push Event"),
                  subtitle: const Text("Pushes/Records an event"),
                  onTap: recordEvent,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Notification Event"),
                  subtitle: const Text("Pushes Notification"),
                  onTap: pushNotification,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("InApp Event"),
                  subtitle: const Text("Pushes InApp Notification"),
                  onTap: inAppNotification,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("App Inbox Event"),
                  subtitle: const Text("Pushes App Inbox Messages"),
                  onTap: appInbox,
                ),
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: const Text("Native Display"),
                  subtitle: const Text("Returns all Display Units set"),
                  onTap: nativeDisplay,
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void login() {
    var profile = {
      'Photo':
      "https://i.pinimg.com/originals/39/95/65/399565162c331db08fde4211da835551.jpg",
    };
    CleverTapPlugin.profileSet(profile);
    // showToast("Pushed profile " + profile.toString());
  }

  void recordEvent() {
    var eventData = {
      'Stuff': 'Shirt',
    };
    // CleverTapPlugin.recordEvent("ProductF Event", eventData);
    // Button Click
    CleverTapPlugin.recordEvent("Button Click", eventData);
    // showToast("ProductF Event Clicked!", context: context);
  }

  void pushNotification() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Push Event", eventData);
    // showToast("Push Event Clicked!", context: context);
  }

  void inAppNotification() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("InApp Event", eventData);
    // showToast("InApp Event Clicked!", context: context);
  }


  // void inAppNotificationButtonClicked(Map<String, dynamic> map) {
  //   this.setState(() {
  //     print("inAppNotificationButtonClicked called = ${map.toString()}");
  //   });
  // }

  void appInbox() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("App Inbox Event", eventData);
    // showToast("App Inbox Event Clicked!", context: context);
    showInbox();
  }

  void showInbox() {
    var styleConfig = {
      'noMessageTextColor': '#ff6600',
      'noMessageText': 'No message(s) to show.',
      'navBarTitle': 'App Inbox'
    };
    CleverTapPlugin.showInbox(styleConfig);
  }

  void nativeDisplay() {
    var eventData = {
      '': '',
    };
    CleverTapPlugin.recordEvent("Native Display Event", eventData);
    getAdUnits();
  }

  void getAdUnits() async {
    var displayUnits = await CleverTapPlugin.getAllDisplayUnits();
    var a = "";
    for (var i in displayUnits!) {
      a = i;
    }
    var decodedJson = json.decode(a);
    var jsonValue = json.decode(decodedJson['content']);
    debugPrint("value = " + jsonValue['message']);
    for (var i = 0; i < displayUnits.length; i++) {
      var units = displayUnits[i];
      displayText(units);
      // debugPrint("units= " + units.toString());
    }
    for (var element in displayUnits) {
      debugPrint("units= " + element[1].toString());
    }
  }

  void displayText(units) {
    for (var i = 0; i < units.length; i++) {
      debugPrint("title= " + units[i].toString());
      // debugPrint("message= " + item.message.toString());

    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:clevertap_plugin/clevertap_plugin.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
//
// class _MyAppState extends State<MyApp> {
//
//   @override
//   void initState() {
//     super.initState();
//     clevertapData();
//     CleverTapPlugin.registerForPush();
//     //only for iOS
//     //var initialUrl = CleverTapPlugin.getInitialUrl();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//
//   }
//
//   void clevertapData() {
//     CleverTapPlugin.setDebugLevel(3);
//     CleverTapPlugin.createNotificationChannel(
//         "fluttertest", "Flutter Test", "Flutter Test", 3, true);
//     CleverTapPlugin.
//     createNotificationChannel("euro", "Name Test", "Description Test", 3, true);
//
//     var profile = {
//       'Name': 'tank',
//       'Identity': 'td135',
//       'DOB': '22-04-2000',
//      'Gender': 'Male',        // Can be either M or F
//
//     //Key always has to be "DOB" and format should always be dd-MM-yyyy
//       'Email': 'tank@gmail.com'
//     };
//     // CleverTapPlugin.onUserLogin(profile);
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       var eventData = {
//         // Key:    Value
//         'click': 'counter'
//       };
//       CleverTapPlugin.recordEvent("Button Click", eventData);
//       CleverTapPlugin.recordScreenView("home 2");
//
//       // var profile = {
//       //   'Name': 'Ryan',
//       //   'Identity': 'RG135',
//       //   'DOB': '22-04-2000',
//       //   //Key always has to be "DOB" and format should always be dd-MM-yyyy
//       //   'Email': 'ryan@gmail.com'
//       // };
//       // CleverTapPlugin.onUserLogin(profile);
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
