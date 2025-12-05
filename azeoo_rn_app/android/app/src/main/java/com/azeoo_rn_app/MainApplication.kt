package com.azeoo_rn_app

import android.app.Application
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactHost
import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainApplication : Application(), ReactApplication {

  override val reactHost: ReactHost by lazy {
    getDefaultReactHost(
      context = applicationContext,
      packageList =
        PackageList(this).packages.apply {
          // Register AzeooPackage
          add(AzeooPackage())
        },
    )
  }

  override fun onCreate() {
    super.onCreate()

    // Initialize and cache FlutterEngine for Add-to-App
    val engineId = "azeoo_engine"
    var flutterEngine = FlutterEngineCache.getInstance().get(engineId)
    
    if (flutterEngine == null) {
      flutterEngine = FlutterEngine(this)
      
      // Execute the default Dart entrypoint
      flutterEngine.dartExecutor.executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
      )
      
      // Cache the engine
      FlutterEngineCache.getInstance().put(engineId, flutterEngine)
    }

    loadReactNative(this)
  }
}
