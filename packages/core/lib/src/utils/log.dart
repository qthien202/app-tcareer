import 'dart:convert';
import 'dart:developer' as developer;

class Log {
  static void d(String message, {String name = 'DEBUG'}) {
    developer.log("🐛 $message", name: name);
  }

  static void i(String message, {String name = 'INFO'}) {
    developer.log("ℹ️ $message", name: name);
  }

  static void w(String message, {String name = 'WARN'}) {
    developer.log("⚠️ $message", name: name);
  }

  static void e(String message, {String name = 'ERROR'}) {
    developer.log("❌ $message", name: name);
  }

  static void json(Object? data, {String name = 'JSON'}) {
    try {
      final prettyString = const JsonEncoder.withIndent('  ').convert(data);
      developer.log("📦 JSON:\n$prettyString", name: name);
    } catch (err) {
      developer.log("❌ Invalid JSON: $err", name: name);
    }
  }
}
