# Omega Dio logger
[![pub version](https://img.shields.io/pub/v/omega_dio_logger?logo=dart)](https://pub.dev/packages/omega_dio_logger)
[![pub likes](https://img.shields.io/pub/likes/omega_dio_logger?logo=dart)](https://pub.dev/packages/omega_dio_logger)
[![dart style](https://img.shields.io/badge/style-carapacik__lints%20-brightgreen?logo=dart)](https://pub.dev/packages/carapacik_lints)

Omega Dio logger is a Dio interceptor that logs network calls in easy to read format with curl command

## Usage

### Install

Add OmegaDioLogger to your Dio interceptors:

```dart
final dio = Dio();

dio.interceptors.add(const OmegaDioLogger());

// or customize
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
```
