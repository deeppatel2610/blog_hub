import 'dart:developer';
import 'package:blog_hub/%20core/network/api_client.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/storage/preference_keys.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  AuthApiService._();

  static AuthApiService authApiService = AuthApiService._();

  // registration
  Future<MessageType> registrationApiCalling({
    required BuildContext context,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      Response response = await ApiClient().apiCalling(
        context: context,
        endpoint: ApiConfig.register,
        method: HttpMethod.post,
        body: {
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
          "password": password,
        },
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 201) {
        return MessageType.success;
      } else if (response.statusCode == 422) {
        AppMessenger.showSnackBar(
          message: response.data['detail'][0]['msg'] ?? "Something went wrong!",
          context,
          type: MessageType.error,
        );
        return MessageType.error;
      } else {
        return MessageType.error;
      }
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return MessageType.error;
    }
  }

  // login
  Future<MessageType> loginApiCalling({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      Response response = await ApiClient().apiCalling(
        context: context,
        endpoint: ApiConfig.login,
        method: HttpMethod.post,
        body: {
          "email": email,
          "password": password,
        },
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        Map decodedToken = JwtDecoder.decode(response.data['access_token']);
        String role = decodedToken['role'];
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (role == "user") {
          sharedPreferences.setBool(PreferenceKeys.isAdmin, false);
        } else {
          sharedPreferences.setBool(PreferenceKeys.isAdmin, true);
        }
        sharedPreferences.setBool(PreferenceKeys.isLoggedIn, true);
        sharedPreferences.setString(PreferenceKeys.role, role);
        sharedPreferences.setString(
            PreferenceKeys.assessToken, response.data['access_token']);
        sharedPreferences.setString(
            PreferenceKeys.tokenType, response.data['token_type']);
        sharedPreferences.setString(PreferenceKeys.email, email);
        sharedPreferences.setString(PreferenceKeys.password, password);
        return MessageType.success;
      } else if (response.statusCode == 400) {
        AppMessenger.showSnackBar(
          message: "Email or password is incorrect!",
          context,
          type: MessageType.error,
        );
        return MessageType.error;
      } else if (response.statusCode == 422) {
        AppMessenger.showSnackBar(
          message: response.data['detail'] ?? "Something went wrong!",
          context,
          type: MessageType.error,
        );
        return MessageType.error;
      } else {
        return MessageType.error;
      }
    } catch (e) {
      AppMessenger.showSnackBar(
        message: "Email or password is incorrect!",
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return MessageType.error;
    }
  }
}
