class LanguageModel {
  String name;
  String type;

  LanguageModel({
    this.name,
    this.type,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
      };
}
