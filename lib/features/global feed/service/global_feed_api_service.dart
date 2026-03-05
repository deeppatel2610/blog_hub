import 'dart:developer';
import 'package:blog_hub/ core/network/api_client.dart';
import 'package:blog_hub/ core/network/api_config.dart';
import 'package:blog_hub/ core/network/get_header.dart';
import 'package:blog_hub/ core/utils/app_messenger.dart';
import 'package:blog_hub/ core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GlobalFeedApiService {
  GlobalFeedApiService._();
  static GlobalFeedApiService globalFeedApiService = GlobalFeedApiService._();

  Future<(MessageType, Response?)> getAllPosts(
      {required BuildContext context}) async {
    try {
      final (token, type) = await GetHeader().getTokens();
      Map<String, dynamic> headers =
      GetHeader().getHeaders(token: token, type: type);
      Response? response = await ApiClient(headers).apiCalling(
        method: HttpMethod.get,
        endpoint: ApiConfig.getPosts,
        context: context,
      );
      if (response == null) return (MessageType.error, null);
      return (MessageType.success, response);
    } catch (e) {
      AppMessenger.showSnackBar(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
      log(e.toString(), level: 1000);
      return (MessageType.error, null);
    }
  }
}