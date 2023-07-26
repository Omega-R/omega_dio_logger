// ignore_for_file: avoid_redundant_argument_values
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:omega_dio_logger/omega_dio_logger.dart';

void main() {
  final dio = Dio();

  dio.interceptors.add(
    const OmegaDioLogger(
      error: true,
      request: true,
      requestHeader: true,
      requestQueryParameters: true,
      requestBody: true,
      response: true,
      responseHeader: true,
      responseBody: true,
      convertFormData: true,
      colorized: true,
      showCurl: true,
      logPrint: print,
      showLog: kDebugMode,
    ),
  );
}
