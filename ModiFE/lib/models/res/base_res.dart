class BaseRes {
  final String message;
  final bool isError;

  bool get isNotError => isError == false;

  BaseRes.fromJson(Map<String, dynamic> json) :
    isError = json["isError"],
    message = json["message"];
}
