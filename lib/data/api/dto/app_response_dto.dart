class AppResponseDTO<T> {
  String? message;
  num? result;
  T? data;

  AppResponseDTO();

  AppResponseDTO.fromJSON(Map<String, dynamic> json, Function parser) {
    message = json["message"];
    result = json["result"];
    data = parser(json["data"]);
  }
}