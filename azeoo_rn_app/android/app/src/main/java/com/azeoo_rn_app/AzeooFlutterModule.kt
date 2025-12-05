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
            android.util.Log.d("AzeooFlutter", "Opening profile for userId=$userId")

            // Start AzeooFlutterActivity with cached engine
            val intent = Intent(reactContext, AzeooFlutterActivity::class.java)
            intent.putExtra("userId", userId)
            intent.putExtra("cached_engine_id", "azeoo_engine")
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            reactContext.startActivity(intent)
            promise?.resolve(true)
        } catch (e: Exception) {
            android.util.Log.e("AzeooFlutter", "Error opening profile", e)
            promise?.reject("OPEN_PROFILE_ERROR", e)
        }
    }
}
