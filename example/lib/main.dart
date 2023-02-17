import 'dart:developer' show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:omega_dio_logger/omega_dio_logger.dart';

void main() {
  final dio = Dio();

  dio.interceptors.add(
    OmegaDioLogger(
      logPrint: log,
      convertFormData: true,
      showError: true,
      showRequest: true,
      showRequestBody: true,
      showRequestHeaders: true,
      showRequestQueryParameters: true,
      showResponse: true,
      showResponseBody: true,
      showResponseHeaders: true,
      showCurl: true,
      showLog: kDebugMode,
    ),
  );
}
