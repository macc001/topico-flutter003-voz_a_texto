import 'package:flutter/material.dart';

import 'package:vozatexto/src/routes/routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: getAplicacionRutas(),
    );
  }
}
