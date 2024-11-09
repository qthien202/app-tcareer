package com.tdev.tcareer

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.clipboard/html"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getHtmlContent") {
                val htmlContent = getHtmlFromClipboard()
                if (htmlContent != null) {
                    result.success(htmlContent)
                } else {
                    result.error("UNAVAILABLE", "No HTML content in clipboard", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getHtmlFromClipboard(): String? {
        val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val primaryClip = clipboard.primaryClip
        if (primaryClip != null && primaryClip.itemCount > 0) {
            val item = primaryClip.getItemAt(0)
            // Check if the clipboard contains HTML
            return item.htmlText ?: item.text?.toString() // Fallback to plain text
        }
        return null
    }
}
