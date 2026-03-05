import 'package:blog_hub/%20core/network/api_client.dart';
import 'package:blog_hub/%20core/network/api_config.dart';
import 'package:blog_hub/%20core/network/get_header.dart';
import 'package:blog_hub/%20core/utils/app_messenger.dart';
import 'package:blog_hub/%20core/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserDashboardApiService {
  UserDashboardApiService._();

  static UserDashboardApiService userDashboardApiService =
      UserDashboardApiService._();

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
      return (MessageType.error, null);
    }
  }
}
