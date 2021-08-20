import 'dart:async';

import 'package:flutter/services.dart';

class Leanplum {
  static const MethodChannel _channel =
      const MethodChannel('run.milk.leanplum');

  static Future<void> start() async {
    await _channel.invokeMethod('start');
    return;
  }

  static Future<void> setAppIdForDevelopmentMode({
    required String appId,
    required String accessKey,
  }) async {
    await _channel.invokeMethod('setAppIdForDevelopmentMode', {
      "appId": appId,
      "accessKey": accessKey,
    });
    return;
  }

  static Future<String?> setAppIdForProductionMode({
    required String appId,
    required String accessKey,
  }) async {
    return await _channel.invokeMethod('setAppIdForProductionMode', {
      "appId": appId,
      "accessKey": accessKey,
    });
  }

  static Future<void> setUserId(String? userId) async {
    return await _channel.invokeMethod('setUserId', {'userId': userId});
  }

  static Future<void> clearUserContent() async {
    return await _channel.invokeMethod('clearUserContent');
  }
}
