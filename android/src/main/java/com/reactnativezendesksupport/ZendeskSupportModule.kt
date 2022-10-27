package com.reactnativezendesksupport

import android.content.Intent
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import zendesk.core.AnonymousIdentity
import zendesk.core.Zendesk
import zendesk.support.Support
import zendesk.support.guide.HelpCenterActivity
import zendesk.support.request.RequestActivity

class ZendeskSupportModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "ZendeskSupport"
  }

  @ReactMethod
  fun initialize(config: ReadableMap, promise: Promise) {
    val appId = config.getString("appId")
    val clientId = config.getString("clientId")
    val zendeskUrl = config.getString("zendeskUrl")
    if (appId == null || clientId == null || zendeskUrl == null) {
      return promise.reject("500", "Invalid parameters")
    }
    Zendesk.INSTANCE.init(reactApplicationContext, zendeskUrl, appId, clientId)
    Support.INSTANCE.init(Zendesk.INSTANCE)
    promise.resolve("Zendesk initialized")
  }

  @ReactMethod
  fun identifyAnonymous(name: String?, email: String?, promise: Promise) {
    if (!Zendesk.INSTANCE.isInitialized) {
      return promise.reject("500", "Zendesk not initialized")
    }
    val identityBuilder = AnonymousIdentity.Builder()
    name?.let { identityBuilder.withNameIdentifier(it) }
    email?.let { identityBuilder.withEmailIdentifier(it) }
    Zendesk.INSTANCE.setIdentity(identityBuilder.build())
    promise.resolve("Anonymous identified")
  }

  @ReactMethod
  fun showHelpCenter(options: ReadableMap?, promise: Promise) {
    if (!Zendesk.INSTANCE.isInitialized) {
      return promise.reject("500", "Zendesk not initialized")
    }
    if (Zendesk.INSTANCE.identity == null) {
      return promise.reject("500", "Zendesk missing identity")
    }
    GlobalScope.launch(Dispatchers.Main) {
      // Help center configuration
      val helpCenterConfigurationBuilder = HelpCenterActivity.builder()
      options?.let {
        helpCenterConfigurationBuilder.withContactUsButtonVisible(
          it.takeIf { it.hasKey("hideContactSupport") }?.getBoolean("hideContactSupport") ?: false
        )
        val groupType = it.takeIf { it.hasKey("groupType") }?.getInt("groupType") ?: return@let
        it.getArray("groupIds")?.let { groupIds ->
          if (groupIds.size() == 0) {
            return@let
          }
          val ids = groupIds.toArrayList().map { groupId -> groupId as Long }
          when (groupType) {
            1 -> helpCenterConfigurationBuilder.withArticlesForSectionIds(ids)
            2 -> helpCenterConfigurationBuilder.withArticlesForCategoryIds(ids)
            else -> {}
          }

        }
      }

      // Ticketing configuration
      val requestConfigurationBuilder = RequestActivity.builder()
      options?.let {
        it.getString("subject")
          ?.let { subject -> requestConfigurationBuilder.withRequestSubject(subject) }
        it.getArray("tags")?.let { tags ->
          if (tags.size() > 0) {
            requestConfigurationBuilder.withTags(tags.toArrayList().map { tag -> tag as String })
          }
        }
      }

      // Help center
      val helpCenter = helpCenterConfigurationBuilder.intent(
        reactApplicationContext, requestConfigurationBuilder.config()
      )
      helpCenter.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      reactApplicationContext.startActivity(helpCenter)
      promise.resolve("Help center created")
    }
  }

}
