
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:interviewai/API/view/ApiService.dart';
import 'package:interviewai/API/model/ChatModel.dart';
import 'package:interviewai/third_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;



class ChatScreen extends StatefulWidget {
  final List<String> messages;
  final int id;
  ChatScreen({required this.messages,required this.id});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  List<String> _messages = [];
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _ctcQuestionsAsked = false;
  bool _sendingMessage = false;
  @override
  void initState() {
    super.initState();
    print('ID>>i: ${widget.id}');
    // // Inside initState() method in ChatScreen
    // SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    // String firstName = prefs.getString('firstName') ?? '';
    // String lastName = prefs.getString('lastName') ?? '';
    // String designation = prefs.getString('designation') ?? '';
    // String industry = prefs.getString('industry') ?? '';
    // String yearsOfExperience = prefs.getString('yearsOfExperience') ?? '';

    _messages = widget.messages;
    _initSpeech();
    _initTts();
    _speakMessages();
    _loadUserDetails();


  }

  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firstName = prefs.getString('firstName') ?? '';
    String lastName = prefs.getString('lastName') ?? '';
    String designation = prefs.getString('designation') ?? '';
    String yearsOfExperience = prefs.getString('yearsOfExperience') ?? '';

    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Designation: $designation');
    print('Years of Experience: $yearsOfExperience');
  }
  Future<void> _initSpeech() async {
    _speechAvailable = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    setState(() {});
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speakMessages() async {
    for (String message in _messages) {
      await _speak(message);
      await Future.delayed(Duration(milliseconds: 500)); // Add a slight delay between messages
    }
  }

  Future<void> _speak(String message) async {
    var result = await _flutterTts.speak(message);
    if (result != 1) {
      print('Failed to speak: $message');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add(_messageController.text);
    });

    String userMessage = _messageController.text;
    _messageController.clear();

    if (_ctcQuestionsAsked) {
      // String prompt = "$userMessage generate 2 questions for current ctc and expected ctc short question";
      //
      // try {
      //   List<ChatModel> responses = await ApiService.sendMessage(
      //     message: prompt,
      //     modelId: 'gpt-3.5-turbo-0301',
      //   );
      //
      //   List<String> messages = responses.map((e) => e.msg).toList();
      //
      //   setState(() {
      //     _messages.addAll(messages);
      //     _ctcQuestionsAsked = true;
      //   });
      //
      //   for (String message in messages) {
      //     await _speak(message);
      //   }
      // } catch (e) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Error"),
      //       content: Text(e.toString()),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text("OK"),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    }
    else {
      // Handle response after CTC questions
      String thankYouMessage = "Thank you for the answer. Please wait, we are scheduling the technical round shortly.";
      setState(() {
        _messages.add(thankYouMessage);
      });

      await _speak(thankYouMessage);

      // // Retrieve data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String firstName = prefs.getString('firstName') ?? '';
      String lastName = prefs.getString('lastName') ?? '';
      String designation = prefs.getString('designation') ?? '';
      String industry = prefs.getString('industry') ?? '';
      String yearsOfExperience = prefs.getString('yearsOfExperience') ?? '';
      print('First Name>>: $firstName');
      print('Last Name: $lastName');
      print('Designation: $designation');
      print('Industry: $industry');
      print('Years of Experience>>: $yearsOfExperience');


      // Delay navigation for 5 seconds
      await Future.delayed(Duration(seconds: 5));
      // Navigate to ThirdScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdScreen(
            firstName: firstName,
            lastName: lastName,
            designation: designation,
            industry: industry,
            yearsOfExperience: yearsOfExperience,
            id: widget.id,
          ),
        ),
      );
    }
  }

  void _startListening() async {
    if (!_isListening && _speechAvailable) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (val) => setState(() {
          _messageController.text = val.recognizedWords;
        }),
        listenFor: Duration(minutes: 1),
        pauseFor: Duration(seconds: 5),
        onSoundLevelChange: (val) => print('sound level: $val'),
        cancelOnError: true,
        partialResults: true,
      );
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ID: ${widget.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text('1st Round'),
        backgroundColor: Colors.black12,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        _messages[index],
                        style: TextStyle(fontSize: 16, color: Colors.brown.shade900),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                _sendingMessage
                    ? CircularProgressIndicator(color: Colors.deepPurple) // Custom color for the progress indicator
                    : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _sendingMessage = true;
                    });
                    _sendMessage().then((_) {
                      setState(() {
                        _sendingMessage = false;
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: Text('Send'),
                ),
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _startListening,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}



