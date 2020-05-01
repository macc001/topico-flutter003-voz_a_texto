import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:vozatexto/src/models/language.model.dart';
// import 'package:vozatexto/src/models/language.model.dart';
import 'package:vozatexto/src/provider/language.Provider.dart';

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class SpechRecognition2 extends StatefulWidget {
  @override
  _SpechRecognition2State createState() => new _SpechRecognition2State();
}

class _SpechRecognition2State extends State<SpechRecognition2> {
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';
  String entidadConocida = "";
  String typo = "";

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final langProvider = new LanguageProvider();

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reconocimiento voz'),
        actions: [
          new PopupMenuButton<Language>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Divider(),
            _label(),
            _entidadCono(),
            _tipo(),
          ],
        ),
      ),
      floatingActionButton: _operacion(),
    );
  }

  Widget _label() {
    return Text('Voz a texto es : $transcription');
  }

  Widget _entidadCono() {
    return Text('Entidad conocida : $entidadConocida');
  }

  Widget _tipo() {
    return Text('tipo : $typo');
  }

  Widget _operacion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 30.0,
        ),
        FloatingActionButton(
          child: Icon(Icons.clear_all),
          onPressed: () {
            setState(() {
              transcription = "";
              typo = "";
              entidadConocida = "";
            });
          },
        ),
        Expanded(child: SizedBox()),
        Expanded(child: SizedBox()),
        FloatingActionButton(
          child: Icon(Icons.stop),
          // onPressed: () {},
          onPressed: () async {
            await _getLanguage();
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        FloatingActionButton(
          child: Icon(Icons.mic),
          onPressed: _speechRecognitionAvailable && !_isListening
              ? () => start()
              : null,
        )
      ],
    );
  }

  _getLanguage() async {
    final List<LanguageModel> productos =
        await langProvider.getLanguage(transcription);
    setState(() {
      entidadConocida = productos[0].name;
      typo = productos[0].type;
    });
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  void start() => _speech
      .listen(locale: selectedLang.code)
      .then((result) => print('start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() =>
      _speech.stop().then((result) => setState(() => _isListening = result));

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => transcription = text);

  void onRecognitionComplete() => setState(() => _isListening = false);
}
