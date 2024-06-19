[![dart style](https://img.shields.io/badge/style-carapacik__lints%20-brightgreen?logo=dart)](https://pub.dev/packages/carapacik_lints)
[![pub version](https://img.shields.io/pub/v/omega_dio_logger?logo=dart)](https://pub.dev/packages/carapacik_dio_logger)
[![pub likes](https://img.shields.io/pub/likes/omega_dio_logger?logo=dart)](https://pub.dev/packages/carapacik_dio_logger)

## Use [carapacik_dio_logger](https://pub.dev/packages/carapacik_dio_logger) instead this package

`OmegaDioLogger` is a `Dio` interceptor that logs network calls in easy to read format with curl command

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
