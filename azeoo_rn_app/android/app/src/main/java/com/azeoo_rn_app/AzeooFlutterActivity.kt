package com.azeoo_rn_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AzeooFlutterActivity : FlutterActivity() {
    private val CHANNEL = "azeoo/channel"
    private var userId: Int = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Read userId from Intent extras
        userId = intent.getIntExtra("userId", 1)
        android.util.Log.d("AzeooFlutterActivity", "onCreate with userId=$userId")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialUserId" -> {
                    android.util.Log.d("AzeooFlutterActivity", "getInitialUserId called, returning $userId")
                    result.success(userId)
                }
                else -> result.notImplemented()
            }
        }
    }
}
