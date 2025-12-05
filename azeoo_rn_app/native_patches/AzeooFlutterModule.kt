package com.azeoo_rn_app

import android.content.Intent
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import io.flutter.embedding.android.FlutterActivity

class AzeooFlutterModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "AzeooFlutter"

    @ReactMethod
    fun openProfile(userId: Int, promise: Promise?) {
        try {
            // Save userId in SharedPreferences for Flutter module to read
            val prefs = reactContext.getSharedPreferences("azeoo_prefs", 0)
            prefs.edit().putInt("azeoo_user_id", userId).apply()

            // Start FlutterActivity with cached engine "azeoo_engine"
            val intent = FlutterActivity
                .withCachedEngine("azeoo_engine")
                .build(reactContext)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            reactContext.startActivity(intent)
            promise?.resolve(true)
        } catch (e: Exception) {
            promise?.reject("OPEN_PROFILE_ERROR", e)
        }
    }
}
