# Omega Dio logger
[![pub version](https://img.shields.io/pub/v/omega_dio_logger?logo=dart)](https://pub.dev/packages/omega_dio_logger)
[![pub likes](https://img.shields.io/pub/likes/omega_dio_logger?logo=dart)](https://pub.dev/packages/omega_dio_logger)

Omega Dio logger is a Dio interceptor that logs network calls in easy to read format with curl command

## Usage

### Install

Add OmegaDioLogger to your Dio interceptors:

```dart
final dio = Dio();

dio.interceptors.add(const OmegaDioLogger());

// or customize interceptor
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
```
