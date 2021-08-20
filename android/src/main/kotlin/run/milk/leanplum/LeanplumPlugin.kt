package run.milk.leanplum

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.leanplum.Leanplum
import com.leanplum.LeanplumPushReceiver
import com.leanplum.internal.Log

/** LeanplumPlugin */
class LeanplumPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Leanplum.setApplicationContext(flutterPluginBinding.applicationContext)
    Leanplum.setLogLevel(Log.Level.DEBUG)

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "run.milk.leanplum")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> {
        Leanplum.start(Leanplum.getContext())
        result.success(null)
      }
      "clearUserContent" -> {
        Leanplum.clearUserContent()
        result.success(null)
      }
      "setUserId" -> {
        if (hasArguments(call, result, "userId")) {
          Leanplum.setUserId(call.argument("userId"))
        }
        result.success(null)
      }
      "setAppIdForProductionMode" -> {
        if (hasArguments(call, result, "appId") && hasArguments(call, result, "accessKey")) {
          Leanplum.setAppIdForProductionMode(call.argument("appId"), call.argument("accessKey"))
        }
        result.success(null)
      }
      "setAppIdForDevelopmentMode" -> {
        if (hasArguments(call, result, "appId") && hasArguments(call, result, "accessKey")) {
          Leanplum.setAppIdForDevelopmentMode(call.argument("appId"), call.argument("accessKey"))
        }
        Leanplum.clearUserContent()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun hasArguments(call: MethodCall, result: Result, vararg keys: String): Boolean {
    if (call.arguments == null) {
      result.error("ARGUMENT_ERROR", "Arguments is empty", null)
      return false
    }
    for (key in keys) {
      if (!call.hasArgument(key)) {
        result.error("ARGUMENT_ERROR", "Key $key is empty", null)
        return false
      }
    }
    return true
  }
}
