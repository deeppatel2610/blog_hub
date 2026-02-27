import 'dart:developer';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiClient {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
    ),
  );

  Future<Response> apiCalling({
    required BuildContext context,
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (method == HttpMethod.get && queryParameters == null) {
        Response response = await dio.get(
          endpoint,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.get && queryParameters != null) {
        Response response = await dio.get(
          endpoint,
          queryParameters: queryParameters,
        );
        return response;
      } else if (method == HttpMethod.post &&
          body != null &&
          queryParameters == null) {
        Response response = await dio.post(
          endpoint,
          data: body,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.post &&
          queryParameters != null &&
          body != null) {
        Response response = await dio.put(
          endpoint,
          data: body,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.post &&
          queryParameters != null &&
          body == null) {
        Response response = await dio.post(
          endpoint,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.put &&
          body != null &&
          queryParameters == null) {
        Response response = await dio.put(
          endpoint,
          data: body,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.put &&
          queryParameters != null &&
          body != null) {
        Response response = await dio.put(
          endpoint,
          data: body,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.put &&
          queryParameters != null &&
          body == null) {
        Response response = await dio.put(
          endpoint,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.delete && queryParameters != null) {
        Response response = await dio.delete(
          endpoint,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else if (method == HttpMethod.delete && queryParameters == null) {
        Response response = await dio.delete(
          endpoint,
          options: Options(
            headers: headers,
          ),
        );
        return response;
      } else {
        throw Exception("Invalid HTTP method");
      }
    } catch (e) {
      log(e.toString(), level: 1000);
      AppMessenger.showSnackBar(
        message: "Something went wrong!",
        context,
        type: MessageType.error,
      );
      rethrow;
    }
  }
}
