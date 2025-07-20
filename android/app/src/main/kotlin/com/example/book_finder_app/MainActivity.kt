package com.example.book_finder_app

import android.hardware.camera2.CameraManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var isFlashOn = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "sensor_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "toggleFlashlight" -> {
                        toggleFlash()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun toggleFlash() {
        val cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        val cameraId = cameraManager.cameraIdList.firstOrNull() ?: return

        isFlashOn = !isFlashOn
        cameraManager.setTorchMode(cameraId, isFlashOn)
    }
}
