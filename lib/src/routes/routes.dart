import 'package:flutter/material.dart';

import 'package:vozatexto/src/pages/speech_recognition2.dart';

Map<String, WidgetBuilder> getAplicacionRutas() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => SpechRecognition2(),
  };
}
