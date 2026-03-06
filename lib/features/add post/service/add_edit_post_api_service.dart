import 'dart:developer';

import 'package:blog_hub/%20core/network/api_client.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/network/get_header.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddEditPostApiService {
  AddEditPostApiService._();

  static final AddEditPostApiService addEditPostApiService =
      AddEditPostApiService._();

  Future<(MessageType, Response?)> addPost(
      {required BuildContext context,
      required Map<String, dynamic> body}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.post,
        endpoint: ApiConfig.post,
        context: context,
        body: body,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      if (response.statusCode == 200) {
        return (MessageType.success, response);
      } else {
        return (MessageType.error, response);
      }
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

  Future<(MessageType, Response?)> updatePost({
    required BuildContext context,
    required Map<String, dynamic> body,
    required String id,
  }) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
          GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.put,
        endpoint: "${ApiConfig.postUpdate}$id",
        context: context,
        body: body,
      );
      if (response == null) {
        return (MessageType.error, null);
      }
      if (response.statusCode == 200) {
        return (MessageType.success, response);
      } else {
        return (MessageType.error, response);
      }
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
