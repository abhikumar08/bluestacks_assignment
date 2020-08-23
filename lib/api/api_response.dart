class ApiResponse {
  bool success;
  dynamic data;
  String message;
  int code;

  ApiResponse();

  @override
  String toString() {
    return "Success : $success \n Message : $message \n Data : $data \n code: $code";
  }

  ApiResponse fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
    code = json['code'];
    return this;
  }
}
