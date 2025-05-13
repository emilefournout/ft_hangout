package com.example.ft_hangout

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import android.Manifest
import android.util.Log

class CallPhone : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, RequestPermissionsResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var numberToCall: String? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.example.ft_hangout/phone")
        channel.setMethodCallHandler(this)
    }


override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method == "callNumber") {
        val numberToCall = call.argument<String>("phone")
        Log.d("CallPhone", "Tentative d'appel vers: $numberToCall")

        if(numberToCall.isNullOrEmpty()){
            result.error("INVALID_ARGUMENT", "Numéro vide", null)
            return
        }

        if(ActivityCompat.checkSelfPermission(activity!!, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED){
            Log.d("CallPhone", "Permission accordée, appel en cours.")
            placeCall(numberToCall)
            result.success(true)
        } else {
            Log.d("CallPhone", "Demande de permission CALL_PHONE.")
            ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.CALL_PHONE), 1001)
            result.success(true)
        }
    } else {
        result.notImplemented()
    }
}

private fun placeCall(number: String) {
    val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$number"))
    activity?.startActivity(intent)
    Log.d("CallPhone", "Intent lancé pour appeler : $number")
}



    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() { activity = null }
    override fun onDetachedFromActivityForConfigChanges() { activity = null }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activity = binding.activity }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) { channel.setMethodCallHandler(null) }

      override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        if(requestCode == 1001 && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED){
            Log.d("CallPhone", "Permission acceptée par l'utilisateur après demande, lancement appel: $numberToCall")
            numberToCall?.let { placeCall(it) }
            return true
        }
        Log.d("CallPhone", "Permission refusée ou erreur: $requestCode")
        return false
    }
}
