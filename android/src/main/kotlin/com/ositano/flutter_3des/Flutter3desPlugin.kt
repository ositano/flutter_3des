package com.ositano.flutter_3des

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

/** Flutter3desPlugin */
public class Flutter3desPlugin: FlutterPlugin, MethodCallHandler {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_3des")
    channel.setMethodCallHandler(Flutter3desPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_3des")
      channel.setMethodCallHandler(Flutter3desPlugin())
    }
  }

  /*
      I feel more comfortable implementing in java
       */
  override fun onMethodCall(call: MethodCall, result: Result) {
    val arguments = call.arguments as ArrayList<*>
    val key = arguments[1] as String
    val iv = arguments[2] as String
    when (call.method) {
      "encrypt" -> result.success(Flutter3desPluginJava.encrypt(arguments[0] as String, key, iv))
      "encryptToHex" -> {
        result.success(Flutter3desPluginJava.encryptToHex(arguments[0] as String, key, iv))
      }
      "decrypt" -> result.success(Flutter3desPluginJava.decrypt(arguments[0] as ByteArray, key, iv))
      "decryptFromHex" -> {
        result.success(Flutter3desPluginJava.decryptFromHex(arguments[0] as String, key, iv))
      }
      else -> result.notImplemented()
    }
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
