import 'dart:convert' show JsonEncoder;
import 'dart:developer' show log;

import 'package:dio/dio.dart';

/// Dio interceptor that logs network calls in a pretty, easy to read format with curl command
class OmegaDioLogger extends Interceptor {
  /// Constructor for interceptor
  const OmegaDioLogger({
    this.logPrint = log,
    this.convertFormData = true,
    this.showError = true,
    this.showRequest = true,
    this.showRequestBody = true,
    this.showRequestHeaders = true,
    this.showRequestQueryParameters = true,
    this.showResponse = true,
    this.showResponseBody = true,
    this.showResponseHeaders = true,
    this.showCurl = true,
    this.showLog = false,
  });

  /// Defines selected method of printing outputs
  /// defaults to log to console
  final void Function(String message) logPrint;

  /// Print FormData
  final bool convertFormData;

  /// Print error message
  final bool showError;

  /// Print request
  final bool showRequest;

  /// Print Request body
  final bool showRequestBody;

  /// Print Request headers
  final bool showRequestHeaders;

  /// Print Request Query parameters
  final bool showRequestQueryParameters;

  /// Print [Response]
  final bool showResponse;

  /// Print [Response.data]
  final bool showResponseBody;

  /// Print [Response.headers]
  final bool showResponseHeaders;

  /// Print cURL
  final bool showCurl;

  /// Enables logging altogether
  final bool showLog;

  /// Defines encoder for intercepted json
  static const _encoder = JsonEncoder.withIndent('\t');

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (showLog) {
      try {
        _logOnError(err);
      } on Object catch (e) {
        logPrint('OmegaDioLogger $e');
      }
    }
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (showLog) {
      try {
        _logOnRequest(options);
      } on Object catch (e) {
        logPrint('OmegaDioLogger $e');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (showLog) {
      try {
        _logOnResponse(response);
      } on Object catch (e) {
        logPrint('OmegaDioLogger $e');
      }
    }
    super.onResponse(response, handler);
  }

  void _logOnError(DioError err) {
    if (!showError) {
      return;
    }
    _errorRepresentation(err);
  }

  void _logOnRequest(RequestOptions options) {
    if (showCurl) {
      _cURLRepresentation(options);
    }
    if (showRequest) {
      _requestRepresentation(options);
    }
    if (showRequestHeaders) {
      _requestHeadersRepresentation(options);
    }
    if (showRequestQueryParameters && options.queryParameters.isNotEmpty) {
      _requestQueryParametersRepresentation(options);
    }
    if (showRequestBody && options.method != 'GET' && options.data != null) {
      _requestBodyRepresentation(options);
    }
  }

  void _logOnResponse(Response<dynamic> response) {
    if (showResponse) {
      _responseRepresentation(response);
    }
    if (showResponseHeaders) {
      _responseHeadersRepresentation(response);
    }
    if (showResponseBody && response.data != null) {
      _responseBodyRepresentation(response);
    }
  }

  void _errorRepresentation(DioError err) {
    if (err.type == DioErrorType.badResponse) {
      _printBoxed(
        'DioError ┃ ${err.response?.statusCode} ┃ ${err.response?.statusMessage}',
        err.response?.requestOptions.uri.toString() ?? 'Empty',
      );

      if (err.response != null && err.response!.data != null) {
        final errorResponseJson = _encoder.convert(err.response!.data);
        _printBoxed('DioErrorBody ┃ ${err.type.name}', errorResponseJson);
      }
    } else {
      _printBoxed('DioError ┃ ${err.type.name}', err.message ?? 'Empty');
    }
  }

  void _requestRepresentation(RequestOptions options) {
    final method = options.method;
    final uri = options.uri;
    _printBoxed('Request ┃ $method', uri.toString());
  }

  void _requestHeadersRepresentation(RequestOptions options) {
    final requestHeaders = <String, dynamic>{}..addAll(options.headers);
    requestHeaders['responseType'] = options.responseType.toString();
    requestHeaders['contentType'] = options.contentType;
    requestHeaders['connectTimeout'] = options.connectTimeout?.inMilliseconds;
    requestHeaders['receiveTimeout'] = options.receiveTimeout?.inMilliseconds;
    requestHeaders['followRedirects'] = options.followRedirects;

    final headersJson = _encoder.convert(requestHeaders);
    _printBoxed('Request Headers', headersJson);
  }

  void _requestQueryParametersRepresentation(RequestOptions options) {
    final queryParametersJson = _encoder.convert(options.queryParameters);
    _printBoxed('Query Parameters', queryParametersJson);
  }

  void _requestBodyRepresentation(RequestOptions options) {
    final dynamic data = options.data;
    if (data is Map) {
      final mapJson = _encoder.convert(data);
      _printBoxed('Request Body', mapJson);
    } else if (data is FormData) {
      final formDataMap = <String, String?>{}
        ..addEntries(data.fields)
        ..addEntries(data.files.map((e) => MapEntry(e.key, e.value.filename)));
      final formDataJson = _encoder.convert(formDataMap);
      _printBoxed('FormData', formDataJson);
    } else {
      _printBoxed('Request Body', data.toString());
    }
  }

  void _responseRepresentation(Response<dynamic> response) {
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri;
    _printBoxed('Response ┃ $method ┃ ${response.statusCode}', uri.toString());
  }

  void _responseHeadersRepresentation(Response<dynamic> response) {
    final responseHeaders = <String, String>{};
    response.headers.forEach((k, v) => responseHeaders[k] = v.toString());
    final responseHeadersJson = _encoder.convert(responseHeaders);
    _printBoxed('Response Headers', responseHeadersJson);
  }

  void _responseBodyRepresentation(Response<dynamic> response) {
    final bodyJson = _encoder.convert(response.data);
    _printBoxed('Response Body', bodyJson);
  }

  void _cURLRepresentation(RequestOptions options) {
    final components = ['curl -i', '-X ${options.method}'];

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    final data = options.data;
    if (data != null) {
      if (data is FormData) {
        if (convertFormData) {
          for (final field in data.fields) {
            components.add('--form ${field.key}="${field.value}"');
          }
          for (final file in data.files) {
            components.add('--form =@"${file.value.filename}"');
          }
        }
      } else if (options.headers['content-type'] ==
          'application/x-www-form-urlencoded') {
        (data as Map).forEach((k, v) => components.add('-d "$k=$v"'));
      } else {
        final dataJson = _encoder.convert(data).replaceAll('"', r'\"');
        components.add('-d "$dataJson"');
      }
    }

    components.add('"${options.uri}"');
    _printBoxed('cURL', components.join(' \\\n\t'));
  }

  void _printBoxed(String header, String text) {
    logPrint('''

┏━━━━━┫ $header ┣━━━━━
$text
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''');
  }
}
