package com.example.fct

import com.clevertap.android.sdk.ActivityLifecycleCallback
import io.flutter.app.FlutterApplication

class AppFCT : FlutterApplication() {
    override fun onCreate() {
        ActivityLifecycleCallback.register(this);
        super.onCreate()
    }
}