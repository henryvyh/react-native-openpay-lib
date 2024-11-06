package com.openpaylib

import android.app.Activity
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.Promise

import mx.openpay.android.Openpay
import mx.openpay.android.OperationCallBack
import mx.openpay.android.OperationResult
import mx.openpay.android.exceptions.OpenpayServiceException
import mx.openpay.android.exceptions.ServiceUnavailableException
import mx.openpay.android.model.Card
import mx.openpay.android.model.Token

class OpenpayLibModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  private lateinit var openpay: Openpay
  private var activity : Activity? = null
  private var initialized : Boolean = false


  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun initOpenpay(args: ReadableMap,promise: Promise ) {
    try {
      val merchantId: String = args.getString("merchantId") ?: ""
      val apiKey: String = args.getString("apiKey") ?: ""
      val productionMode: Boolean = args.getBoolean("productionMode")

      this.openpay = Openpay(merchantId, apiKey, productionMode)
      this.initialized = true
      promise.resolve(true)
    } catch (e: Exception) {
      promise.reject("INIT_ERROR", "Failed to initialize Openpay", e)
    }
    
  }

  @ReactMethod
  fun getDeviceSessionId(promise: Promise) {
    if (!initialized) {
      promise.reject("NOT_INITIALIZED", "Openpay is not initialized")
      return
    }
    val currentActivity = reactApplicationContext.currentActivity
    try {
        val deviceSessionId = openpay.deviceCollectorDefaultImpl.setup(currentActivity)
        promise.resolve(deviceSessionId)
    } catch (e: Exception) {
      promise.reject("DEVICE_SESSION_ERROR", "Failed to get device session ID", e)
    }
  }

    
  @ReactMethod
  fun createToken(cardDetails: ReadableMap, promise: Promise) {
    if (!initialized) {
      promise.reject("NOT_INITIALIZED", "Openpay is not initialized")
      return
    }

    val card = Card().apply {
      holderName = cardDetails.getString("holderName")
      cardNumber = cardDetails.getString("cardNumber")
      expirationMonth = cardDetails.getString("expirationMonth")
      expirationYear = cardDetails.getString("expirationYear")
      cvv2 = cardDetails.getString("cvv")
    }

    openpay.createToken(card, object : OperationCallBack<Token> {
      override fun onSuccess(operationResult: OperationResult<Token>?) {
        val token = operationResult?.result
          println("Generated Token: $token") 
          promise.resolve(token?.id)
      }

      override fun onError(serviceException: OpenpayServiceException?) {
        val errorCode = serviceException?.errorCode.toString()
        val errorDescription = when (serviceException?.errorCode) {
          3001 -> "The card was declined by the bank."
          3002 -> "The card has expired."
          3003 -> "Insufficient funds."
          3004 -> "The card was reported as stolen."
          3005 -> "Fraud suspected."
          else -> "Error code: $errorCode. Check Openpay documentation for details."
        }
        promise.reject(errorCode, errorDescription)
      }

      override fun onCommunicationError(serviceException: ServiceUnavailableException?) {
        promise.reject("COMMUNICATION_ERROR", serviceException?.message)
      }
    })
  }

  companion object {
    const val NAME = "OpenpayLib"
  }
}
