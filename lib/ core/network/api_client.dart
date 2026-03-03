import 'dart:developer';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/network/global_internet_speed_service.dart';
import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<Response> _callApi({
    required BuildContext context,
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final Response response = await dio.request(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      String errorMessage = e.message ?? "An error occurred";
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }

      AppMessenger.showSnackBar(
        context,
        message: errorMessage,
        type: MessageType.error,
      );
      rethrow;
    }
  }

  Future<Response?> apiCalling({
    required BuildContext context,
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic body, // Supports Map or FormData
    Map<String, dynamic>? headers,
  }) async {
    final status = await GlobalNetworkChecker().checkSpeed();
    if (status == NetworkStatus.noInternet) {
      AppMessenger.showAlertDialog(
        context,
        title: 'No internet connection',
        message: 'Please check your internet connection and try again.',
        type: MessageType.error,
        confirmLabel: 'OK',
      );
      return null;
    }

    if (status == NetworkStatus.slow) {
      AppMessenger.showSnackBar(
        context,
        message: 'Slow internet connection...',
        type: MessageType.warning,
      );
    } else if (status == NetworkStatus.medium) {
      log("Connection is medium speed");
    }

    // Helper to auto-inject tokens if headers aren't manually passed
    Map<String, dynamic> finalHeaders = headers ?? {};
    if (finalHeaders.isEmpty) {
      final tokens = await getTokens();
      if (tokens.$1.isNotEmpty) {
        finalHeaders = getHeaders(token: tokens.$1, type: tokens.$2);
      }
    }

    return await _callApi(
      context: context,
      endpoint: endpoint,
      method: method,
      queryParameters: queryParameters,
      body: body,
      headers: finalHeaders,
    );
  }

  Future<(String, String)> getTokens() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(PreferenceKeys.assessToken) ?? "";
    final type = sharedPreferences.getString(PreferenceKeys.tokenType) ?? "";
    return (token, type);
  }

  Map<String, dynamic> getHeaders(
      {required String token, required String type}) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}
