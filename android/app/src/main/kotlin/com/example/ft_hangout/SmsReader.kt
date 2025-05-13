package com.example.ft_hangout

import android.content.ContentResolver
import android.database.Cursor
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.telephony.SmsManager

class SmsReader : FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: Result? = null

    companion object {
        const val CHANNEL = "com.example.sms_reader"
        const val READ_SMS_PERMISSION_REQUEST_CODE = 12345
        const val SEND_SMS_PERMISSION_REQUEST_CODE = 12346
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getAllSMS" -> {
                pendingResult = result
                if (ActivityCompat.checkSelfPermission(activity!!, android.Manifest.permission.READ_SMS)
                    == PackageManager.PERMISSION_GRANTED
                ) {
                    result.success(getAllSms())
                } else {
                    ActivityCompat.requestPermissions(
                        activity!!,
                        arrayOf(android.Manifest.permission.READ_SMS),
                        READ_SMS_PERMISSION_REQUEST_CODE
                    )
                }
            }

            "sendSMS" -> {
                val phone = call.argument<String>("phone")
                val msg = call.argument<String>("msg")
                if (phone == null || msg == null) {
                    result.error("INVALID_ARGUMENTS", "Arguments invalides", null)
                    return
                }
                pendingResult = result
                if (ActivityCompat.checkSelfPermission(activity!!, android.Manifest.permission.SEND_SMS)
                    == PackageManager.PERMISSION_GRANTED
                ) {
                    sendSms(phone, msg)
                    result.success(true)
                } else {
                    ActivityCompat.requestPermissions(
                        activity!!,
                        arrayOf(android.Manifest.permission.SEND_SMS),
                        SEND_SMS_PERMISSION_REQUEST_CODE
                    )
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun getAllSms(): List<Map<String, String>> {
        val smsList = mutableListOf<Map<String, String>>()
        val resolver: ContentResolver = activity!!.contentResolver
        val uriSms = Uri.parse("content://sms/")
        val cursor: Cursor? = resolver.query(uriSms, null, null, null, null)
        cursor?.use {
            while (it.moveToNext()) {
                val msgData = mutableMapOf<String, String>()
                for (idx in 0 until cursor.columnCount) {
                    msgData[cursor.getColumnName(idx)] = cursor.getString(idx) ?: ""
                }
                smsList.add(msgData)
            }
        }
        return smsList
    }

    private fun sendSms(phone: String, message: String) {
        val smsManager = SmsManager.getDefault()
        smsManager.sendTextMessage(phone, null, message, null, null)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            READ_SMS_PERMISSION_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    pendingResult?.success(getAllSms())
                } else {
                    pendingResult?.error("PERMISSION_DENIED", "Permission refusée", null)
                }
                pendingResult = null
                return true
            }

            SEND_SMS_PERMISSION_REQUEST_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    pendingResult?.success(true)
                } else {
                    pendingResult?.error("PERMISSION_DENIED", "Permission SMS refusée", null)
                }
                pendingResult = null
                return true
            }
        }
        return false
    }
}
