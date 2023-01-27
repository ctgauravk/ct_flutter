package com.clevertap.fct

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.clevertap.android.sdk.CleverTapAPI
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    var cleverTapDefaultInstance: CleverTapAPI? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
     }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        cleverTapDefaultInstance = CleverTapAPI.getDefaultInstance(applicationContext)

    }
//    override fun onNewIntent(intent: Intent?) {
//        super.onNewIntent(intent)
//
//        Log.e("load", "called")
//        // On Android 12, Raise notification clicked event when Activity is already running in activity backstack
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//            cleverTapDefaultInstance?.pushNotificationClickedEvent(intent!!.extras)
//        }
//    }
}
