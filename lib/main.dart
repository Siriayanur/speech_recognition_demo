import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: SpeechText(),
    );
  }
}

class SpeechText extends StatefulWidget {
  @override
  _SpeechTextState createState() => _SpeechTextState();
}

class _SpeechTextState extends State<SpeechText> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result) {
      setState(() {
        _isAvailable = result;
      });
    });
    _speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
      });
    });

    _speechRecognition.setRecognitionResultHandler((String text) {
      setState(() {
        resultText = text;
      });
    });
    _speechRecognition.setRecognitionCompleteHandler(() {
      setState(() {
        _isListening = false;
      });
    });
    _speechRecognition.activate().then((result) {
      setState(() {
        _isAvailable = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.brown,
                  child: Icon(Icons.cancel),
                  onPressed: () {
                    if(_isListening){
                      _speechRecognition.cancel().then((value) => setState((){
                        _isListening = value;
                        resultText = "";
                      }));
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if(_isAvailable && !_isListening){
                      _speechRecognition.listen(locale: "en_US").then((value) => print('$value'));
                    }
                  },
                  backgroundColor: Colors.blueAccent,
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () {
                    if(_isListening){
                      _speechRecognition.stop().then((value) => setState(() => _isListening = value));
                    }
                  },
                  mini: true,
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
            Container(
              child: Text(resultText),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.black
              ),
            )
          ],
        ),
      ),
    );
  }
}
