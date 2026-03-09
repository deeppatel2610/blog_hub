import 'dart:async';
import 'dart:developer';
import 'package:blog_hub/%20core/network/global_internet_speed_service.dart';
import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  Dio dio = Dio();

  ApiClient(Map<String, dynamic> headers) {
    dio.options.baseUrl = ApiConfig.baseUrl;
    dio.options.headers.addAll(headers);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            if (error.requestOptions.path == ApiConfig.login) {
              return handler.next(error);
            }

            SharedPreferences prefs = await SharedPreferences.getInstance();
            String username = prefs.getString(PreferenceKeys.username) ?? "";
            String password = prefs.getString(PreferenceKeys.password) ?? "";

            if (username.isNotEmpty && password.isNotEmpty) {
              Response loginResponse = await dio.post(
                ApiConfig.login,
                options: Options(headers: {
                  "Content-Type": "application/x-www-form-urlencoded"
                }),
                data: {
                  "username": username,
                  "password": password,
                },
              );
              if (loginResponse.statusCode == 200) {
                String accessToken = loginResponse.data["access_token"];
                String tokenType = loginResponse.data["token_type"];
                prefs.setString(PreferenceKeys.assessToken, accessToken);
                prefs.setString(PreferenceKeys.tokenType, tokenType);
                dio.options.headers["Authorization"] =
                    "$tokenType $accessToken";
                error.requestOptions.headers["Authorization"] =
                    "$tokenType $accessToken";

                final response = await Dio().fetch(error.requestOptions);
                return handler.resolve(response);
              }
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
        onRequest: (options, handler) {
          log("FULL URL => ${options.uri}");
          log("METHOD => ${options.method}");
          log("HEADERS => ${options.headers}");
          log("DATA => ${options.data}");
          handler.next(options);
        },
      ),
    );
  }

  Future<Response?> _apiCall({
    required BuildContext context,
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      switch (method) {
        case HttpMethod.post:
          return await dio.post(
            endpoint,
            queryParameters: queryParameters,
            data: body,
          );

        case HttpMethod.put:
          return await dio.put(
            endpoint,
            queryParameters: queryParameters,
            data: body,
          );

        case HttpMethod.get:
          return await dio.get(
            endpoint,
            queryParameters: queryParameters ?? {},
            data: body ?? "",
          );

        case HttpMethod.delete:
          return await dio.delete(
            endpoint,
            queryParameters: queryParameters,
          );
      }
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
    }

    return null;
  }

  Future<Response?> apiCalling({
    required BuildContext context,
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    NetworkStatus status = await GlobalNetworkChecker().checkSpeed();

    try {
      switch (status) {
        case NetworkStatus.fast:
          return await _apiCall(
            context: context,
            endpoint: endpoint,
            method: method,
            queryParameters: queryParameters,
            body: body,
          );

        case NetworkStatus.medium:
        case NetworkStatus.slow:
          AppMessenger.showSnackBar(
            message: "Slow internet connection",
            context,
            type: MessageType.error,
          );
          return null;

        case NetworkStatus.noInternet:
          AppMessenger.showAlertDialog(
            context,
            title: "No Internet",
            message: "Please check your internet connection.",
          );
          return null;
      }
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
    }

    return null;
  }
}
