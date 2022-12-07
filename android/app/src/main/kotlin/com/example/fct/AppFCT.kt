package com.example.fct

import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.sdk.pushnotification.CTPushNotificationListener
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import io.flutter.plugins.GeneratedPluginRegistrant



class AppFCT : FlutterApplication(), CTPushNotificationListener,
    PluginRegistry.PluginRegistrantCallback {

    var channel: MethodChannel? = null
    private val CHANNEL = "myChannel"

    override fun onCreate() {
        ActivityLifecycleCallback.register(this)
        super.onCreate()

        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.DEBUG);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CleverTapAPI.createNotificationChannelGroup(this, "YourGroupId", "YourGroupName")
        }
        CleverTapAPI.createNotificationChannel(
            applicationContext,
            "testkk123",
            "test",
            "test",
            NotificationManager.IMPORTANCE_MAX,
            true
        )
        val cleverTapAPI = CleverTapAPI.getDefaultInstance(applicationContext)
        cleverTapAPI!!.ctPushNotificationListener = this
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
//        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
//        FlutterFirebaseMessagingBackgroundS
    }

    fun GetMethodChannel(context: Context, r: Map<String, Any>) {
        FlutterMain.startInitialization(context)
        FlutterMain.ensureInitializationComplete(context, arrayOfNulls(0))
        val engine = FlutterEngine(context.applicationContext)
        val entrypoint = DartExecutor.DartEntrypoint("lib/main.dart", "main")
        engine.dartExecutor.executeDartEntrypoint(entrypoint)

        MethodChannel(
            engine.dartExecutor.binaryMessenger,
            CHANNEL
        ).invokeMethod("onPushNotificationClicked", r,
            object : MethodChannel.Result {
                override fun success(o: Any?) {
                    Log.d("Results", o.toString())
                }

                override fun error(s: String, s1: String?, o: Any?) {
                    Log.d("No result as error", o.toString())
                }

                override fun notImplemented() {
                    Log.d("No result as error", "cant find ")
                }
            })
    }

    override fun onNotificationClickedPayloadReceived(payload: HashMap<String, Any>?) {
        Log.d("worked", payload.toString())
        GetMethodChannel(this, payload!!)
    }

    override fun registerWith(registry: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith((registry as FlutterEngine?)!!)
    }


}