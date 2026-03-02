import 'dart:developer';

import 'package:blog_hub/%20core/network/api_client.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AdminDashboardApiService {
  AdminDashboardApiService._();

  static AdminDashboardApiService adminDashboardApiService =
      AdminDashboardApiService._();

  Future<(MessageType, Response?)> getAllUsers(
      {required BuildContext context}) async {
    try {
      Response response = await ApiClient().apiCalling(
        method: HttpMethod.get,
        endpoint: ApiConfig.users,
        context: context,
      );
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
      Response response = await ApiClient().apiCalling(
        method: HttpMethod.get,
        endpoint: "${ApiConfig.user}$id",
        context: context,
      );
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
      Response response = await ApiClient().apiCalling(
        method: HttpMethod.put,
        endpoint: "${ApiConfig.user}$id",
        context: context,
        body: body,
      );
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
      Response response = await ApiClient().apiCalling(
        method: HttpMethod.delete,
        endpoint: "${ApiConfig.userDeactivate}$id",
        context: context,
      );
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
      Response response = await ApiClient().apiCalling(
        method: HttpMethod.delete,
        endpoint: "${ApiConfig.userHardDelete}$id",
        context: context,
      );
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
