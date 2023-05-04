// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

class RestClient extends GetConnect {
  //final _appBaseUrl = 'https://way-dev.webrouter.com.br/appTracking';
  final _appBaseUrl = 'http://192.168.0.102:8095/tracking';
  //final _appBaseUrl = 'http://192.168.0.87:8095/tracking';

  RestClient() {
    httpClient.baseUrl = _appBaseUrl;
  }
}

class RestClientException implements Exception {
  final int? code;
  final String message;

  RestClientException(
    this.message, {
    this.code,
  });

  @override
  String toString() => 'RestClientException(code: $code, message: $message)';
}
