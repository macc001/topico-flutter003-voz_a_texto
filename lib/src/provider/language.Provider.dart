import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vozatexto/src/models/language.model.dart';

class LanguageProvider {
  Map<String, String> header = {"Content-Type": "application/json"};

  final String _key = "AIzaSyCafW2_rJhFr26fQ53gjBgxs5BjUB4fM7I";
  final String _url =
      "https://language.googleapis.com/v1/documents:analyzeEntities";

  Future<List<LanguageModel>> getLanguage(String _context) async {
    print(_context);
    final String url = '$_url?key=$_key';
    Map<String, dynamic> texto = {
      "encodingType": "UTF8",
      'document': {"type": "PLAIN_TEXT", "content": "$_context"},
    };
    print(texto);
    final resp2 =
        await http.post(url, headers: header, body: json.encode(texto));
    final Map<String, dynamic> decodedData = json.decode(resp2.body);
    final List<LanguageModel> language = [];
    if (decodedData == null) return [];
    // print(decodedData["entities"]);
    for (var jsonLangu in decodedData["entities"]) {
      language.add(LanguageModel.fromJson(jsonLangu));
    }
    return language;
  }
}
