import 'package:bulk_sms_sender/sms.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//region EDIT VALUES HERE
/// ------------------ EDIT START ------------------
const String csvFilepath = 'assets/formular-sample-Mesaj pentru elevi cu prieteni - Sheet1 2023-01-17_20-25-10.csv';
const int numberRow = 3;
const int nameRow = 1;

String firstnameToMessage(String firstname) {
  return '''Sâmbătă e ziua cea mare! De la ora 12:00 are loc evenimetul de deschidere „Earthrise”! 🤩

Dacă nu ai făcut-o deja, te invităm să completezi formularul de participare (https://forms.gle/JN7oc9FQ4V6zcKXb7) și să îți pregătești entuziasmul! Vom petrece împreună câteva ore relaxante, vom socializa și ne vom distra. 🤗

Și ca tot veni vorba de distracție, știm ca totul e mai fun cu prietenii, motiv pentru care ne-ar face mare plăcere să-i inviți și pe ei! 🥳
Invită un prieten, dă-i și lui șansa de a ne descoperi, iar pe viitor puteți participa împreună la atelierele noastre! 

Let’s do ittt!⚡️

P.s: Da, și prietenii tăi trebuie să completeze formularul de participare.''';
}
/// ------------------ EDIT END ------------------
//endregion

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


SMS excelRowToSMS(List<dynamic> row) {
  var number = row[numberRow].toString().trim();
  var firstname = row[nameRow].toString().trim();
  print('number: $number, firstname: $firstname');

  return SMS(number, firstnameToMessage(firstname));
}


List<SMS> convertExcelDataToSMSList(String data) {
  var listFromCSV = const CsvToListConverter().convert(data, eol: "\n");
  return listFromCSV.sublist(1).map((row) => excelRowToSMS(row)).toList();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  static List<SMS> SAMPLE_SMS_LIST = [
    SMS("0756587313", "--------------------"),
    SMS("0756587313", "Test 1: ${DateTime.now()}"),
    SMS("0756587313", "Test 2: ${DateTime.now()}"),
    SMS("0756587313", "Multi\nline\nmessage"),
  ];

  var smsList = SAMPLE_SMS_LIST;

  void readCSVFile() async {
    var csvData = await rootBundle.loadString(csvFilepath);

    smsList = convertExcelDataToSMSList(csvData);
  }

  void _sendSMSes() {
    logSMSes();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Send SMSes"),
              content: const Text(
                  "Are you sure you want to send the SMSes?\nCHECK THE LOGS FIRST!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _counter++;

                        SMS.sendSMSs(smsList);
                      });
                    },
                    child: const Text("Send"))
              ],
            ));
  }

  void logSMSes() {
    print("SMSes --------------------------------------------------");
    var i = 1;
    for (var element in smsList) {
      print('$i: $element');
      i++;
    }
    print("SMSes --------------------------------------------------");
  }

  @override
  Widget build(BuildContext context) {
    print('Sunt apelata de mai multe ori?');
    readCSVFile();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendSMSes,
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
