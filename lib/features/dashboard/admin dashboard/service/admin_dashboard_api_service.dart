import 'dart:developer';

import 'package:blog_hub/%20core/network/api_client.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/network/get_header.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardApiService {
  AdminDashboardApiService._();

  static AdminDashboardApiService adminDashboardApiService =
      AdminDashboardApiService._();

  Future<(MessageType, Response?)> getAllUsers(
      {required BuildContext context}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.get,
        endpoint: ApiConfig.users,
        context: context,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }

  Future<(MessageType, Response?)> getUserById(
      {required BuildContext context, required String id}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.get,
        endpoint: "${ApiConfig.user}$id",
        context: context,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }

  Future<(MessageType, Response?)> updateUser(
      {required BuildContext context,
      required String id,
      required Map<String, dynamic> body}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);

      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.put,
        endpoint: "${ApiConfig.user}$id",
        context: context,
        body: body,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }

  Future<(MessageType, Response?)> deactivateUser(
      {required BuildContext context, required String id}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.delete,
        endpoint: "${ApiConfig.userDeactivate}$id",
        context: context,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }

  Future<(MessageType, Response?)> hardDeleteUser(
      {required BuildContext context, required String id}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.delete,
        endpoint: "${ApiConfig.userHardDelete}$id",
        context: context,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        message: e.toString(),
        context,
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }
}
