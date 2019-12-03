/*
 *  Copyright 2019 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
@file:Suppress("FunctionName")

package com.tuarua.facebookane

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.util.Base64
import com.adobe.air.AndroidActivityWrapper
import com.adobe.air.FreKotlinActivityResultCallback
import com.adobe.air.FreKotlinStateChangeCallback
import com.facebook.*
import com.facebook.login.DefaultAudience
import com.facebook.login.LoginBehavior
import com.facebook.login.LoginManager
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import com.google.gson.Gson
import com.tuarua.facebookane.data.FacebookEvent
import com.facebook.FacebookException
import com.facebook.login.LoginResult
import com.facebook.FacebookCallback
import com.facebook.internal.FacebookDialogBase
import com.facebook.share.ShareApi
import com.facebook.share.Sharer
import com.facebook.share.model.ShareContent
import com.facebook.share.model.ShareLinkContent
import com.facebook.share.widget.MessageDialog
import com.facebook.share.widget.ShareDialog
import com.tuarua.facebookane.extensions.ShareLinkContent
import com.tuarua.facebookane.extensions.SharePhotoContent
import com.tuarua.facebookane.extensions.ShareVideoContent
import com.tuarua.facebookane.extensions.toMap
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "DEPRECATION")
class KotlinController : FreKotlinMainController, FreKotlinStateChangeCallback, FreKotlinActivityResultCallback {
    private var onShareSuccessEventId: String? = null
    private var onShareCancelEventId: String? = null
    private var onShareErrorEventId: String? = null
    private var callbackManager: CallbackManager? = null
    private lateinit var accessTokenTracker: AccessTokenTracker
    private lateinit var activity: Activity
    private var shareDialogs: MutableMap<String, ShareDialog> = mutableMapOf()
    private var messageDialogs: MutableMap<String, MessageDialog> = mutableMapOf()
    private var shareAPIs: MutableMap<String, ShareApi> = mutableMapOf()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    // FacebookSdk

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val applicationId = String(argv[0]) ?: return null
        val onCurrentAccessTokenChangedEventId = String(argv[1])
        val isAdvertiserIDCollectionEnabled = Boolean(argv[2]) == true
        val isAutoLogAppEventsEnabled = Boolean(argv[3]) == true

        activity = context?.activity ?: return null
        FacebookSdk.setApplicationId(applicationId)
        FacebookSdk.setAutoInitEnabled(false)
        FacebookSdk.setAdvertiserIDCollectionEnabled(isAdvertiserIDCollectionEnabled)
        FacebookSdk.sdkInitialize(activity) { }

        FacebookSdk.setAutoLogAppEventsEnabled(isAutoLogAppEventsEnabled)

        callbackManager = CallbackManager.Factory.create()
        if (onCurrentAccessTokenChangedEventId != null) {
            accessTokenTracker = object : AccessTokenTracker() {
                override fun onCurrentAccessTokenChanged(oldToken: AccessToken?, newToken: AccessToken?) {
                    dispatchEvent(FacebookEvent.ON_CURRENT_ACCESS_TOKEN_CHANGED,
                            Gson().toJson(FacebookEvent(onCurrentAccessTokenChangedEventId,
                                    mapOf("oldToken" to oldToken.toMap(), "newToken" to newToken.toMap())))
                    )
                }
            }
        }

        return true.toFREObject()
    }

    fun getSdkVersion(ctx: FREContext, argv: FREArgv): FREObject? {
        return FacebookSdk.getSdkVersion().toFREObject()
    }

    fun setIsDebugEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        FacebookSdk.setIsDebugEnabled(Boolean(argv[0]) == true)
        return null
    }

    fun isDebugEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        return FacebookSdk.isDebugEnabled().toFREObject()
    }

    fun addLoggingBehavior(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        FacebookSdk.addLoggingBehavior(loggingBehaviorFromInt(Int(argv[0]) ?: 0))
        return null
    }

    fun removeLoggingBehavior(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        FacebookSdk.removeLoggingBehavior(loggingBehaviorFromInt(Int(argv[0]) ?: 0))
        return null
    }

    fun clearLoggingBehaviors(ctx: FREContext, argv: FREArgv): FREObject? {
        FacebookSdk.clearLoggingBehaviors()
        return null
    }

    fun isLoggingBehaviorEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        return FacebookSdk.isLoggingBehaviorEnabled(loggingBehaviorFromInt(Int(argv[0])
                ?: 0)).toFREObject()
    }

    fun getLimitEventAndDataUsage(ctx: FREContext, argv: FREArgv): FREObject? {
        return FacebookSdk.getLimitEventAndDataUsage(activity).toFREObject()
    }

    fun setLimitEventAndDataUsage(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        FacebookSdk.setLimitEventAndDataUsage(activity, Boolean(argv[0]) == true)
        return null
    }

    @SuppressLint("PackageManagerGetSignatures")
    fun getHashKey(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            val info = activity.packageManager.getPackageInfo(
                    activity.packageName,
                    PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                return Base64.encodeToString(md.digest(), Base64.DEFAULT).toFREObject()
            }
        } catch (e: PackageManager.NameNotFoundException) {
            return FreException(e).getError()
        } catch (e: NoSuchAlgorithmException) {
            return FreException(e).getError()
        }

        return null
    }

    fun isInitialized(ctx: FREContext, argv: FREArgv): FREObject? {
        return FacebookSdk.isInitialized().toFREObject()
    }

    fun setIsAdvertiserIDCollectionEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        if (FacebookSdk.isInitialized()) FacebookSdk.setAdvertiserIDCollectionEnabled(Boolean(argv[0]) == true)
        return null
    }

    fun setIsAutoLogAppEventsEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        if (FacebookSdk.isInitialized()) FacebookSdk.setAutoLogAppEventsEnabled(Boolean(argv[0]) == true)
        return null
    }

    // LoginManager

    fun login(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 4 } ?: return FreArgException()
        val permissions = List<String>(FREArray(argv[0]))
        val withPublish = Boolean(argv[1]) == true
        val onSuccessEventId = String(argv[2]) ?: return null
        val onCancelEventId = String(argv[3]) ?: return null
        val onErrorEventId = String(argv[4]) ?: return null

        LoginManager.getInstance().registerCallback(callbackManager, object : FacebookCallback<LoginResult> {
            override fun onSuccess(loginResult: LoginResult) {
                dispatchEvent(FacebookEvent.ON_LOGIN_SUCCESS,
                        Gson().toJson(FacebookEvent(onSuccessEventId,
                                mapOf("accessToken" to loginResult.accessToken.toMap(),
                                        "recentlyGrantedPermissions" to loginResult.recentlyGrantedPermissions,
                                        "recentlyDeniedPermissions" to loginResult.recentlyDeniedPermissions)))
                )
                LoginManager.getInstance().unregisterCallback(callbackManager)
            }

            override fun onCancel() {
                dispatchEvent(FacebookEvent.ON_LOGIN_CANCEL,
                        Gson().toJson(FacebookEvent(onCancelEventId))
                )
                LoginManager.getInstance().unregisterCallback(callbackManager)
            }

            override fun onError(error: FacebookException) {
                dispatchEvent(FacebookEvent.ON_LOGIN_ERROR,
                        Gson().toJson(FacebookEvent(onErrorEventId,
                                mapOf("message" to error.localizedMessage))
                        )
                )
                LoginManager.getInstance().unregisterCallback(callbackManager)
            }
        })
        if (withPublish) LoginManager.getInstance().logInWithPublishPermissions(activity, permissions)
        else LoginManager.getInstance().logInWithReadPermissions(activity, permissions)
        return null
    }

    fun logout(ctx: FREContext, argv: FREArgv): FREObject? {
        LoginManager.getInstance().logOut()
        return null
    }

    fun getLoginBehavior(ctx: FREContext, argv: FREArgv): FREObject? {
        return LoginManager.getInstance().loginBehavior.ordinal.toFREObject()
    }


    fun setLoginBehavior(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        when (Int(argv[0]) ?: 0) {
            0 -> LoginManager.getInstance().loginBehavior = LoginBehavior.NATIVE_WITH_FALLBACK
            1 -> LoginManager.getInstance().loginBehavior = LoginBehavior.NATIVE_ONLY
            2 -> LoginManager.getInstance().loginBehavior = LoginBehavior.KATANA_ONLY
            3 -> LoginManager.getInstance().loginBehavior = LoginBehavior.WEB_ONLY
            4 -> LoginManager.getInstance().loginBehavior = LoginBehavior.WEB_VIEW_ONLY
            5 -> LoginManager.getInstance().loginBehavior = LoginBehavior.DIALOG_ONLY
            6 -> LoginManager.getInstance().loginBehavior = LoginBehavior.DEVICE_AUTH
        }
        return null
    }

    fun getDefaultAudience(ctx: FREContext, argv: FREArgv): FREObject? {
        return LoginManager.getInstance().defaultAudience.ordinal.toFREObject()
    }

    fun setDefaultAudience(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        when (Int(argv[0]) ?: 0) {
            0 -> LoginManager.getInstance().defaultAudience = DefaultAudience.NONE
            1 -> LoginManager.getInstance().defaultAudience = DefaultAudience.ONLY_ME
            2 -> LoginManager.getInstance().defaultAudience = DefaultAudience.FRIENDS
            3 -> LoginManager.getInstance().defaultAudience = DefaultAudience.EVERYONE
        }
        return null
    }

    // AccessToken

    fun getCurrentAccessToken(ctx: FREContext, argv: FREArgv): FREObject? {
        val accessToken = AccessToken.getCurrentAccessToken()
        return Gson().toJson(accessToken.toMap()).toFREObject()
    }

    fun refreshCurrentAccessTokenAsync(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val onTokenRefreshedEventId = String(argv[0]) ?: return null
        val onTokenRefreshFailedEventId = String(argv[1]) ?: return null
        AccessToken.refreshCurrentAccessTokenAsync(object : AccessToken.AccessTokenRefreshCallback {
            override fun OnTokenRefreshed(accessToken: AccessToken) {
                dispatchEvent(FacebookEvent.ON_TOKEN_REFRESH,
                        Gson().toJson(FacebookEvent(onTokenRefreshedEventId, accessToken.toMap()))
                )
            }

            override fun OnTokenRefreshFailed(exception: FacebookException) {
                dispatchEvent(FacebookEvent.ON_TOKEN_REFRESH_FAILED,
                        Gson().toJson(FacebookEvent(onTokenRefreshFailedEventId,
                                mapOf("message" to exception.localizedMessage))
                        )
                )
            }
        })
        return null
    }

    fun isCurrentAccessTokenActive(ctx: FREContext, argv: FREArgv): FREObject? {
        return AccessToken.isCurrentAccessTokenActive().toFREObject()
    }

    fun isDataAccessActive(ctx: FREContext, argv: FREArgv): FREObject? {
        return AccessToken.isDataAccessActive().toFREObject()
    }

    private fun loggingBehaviorFromInt(value: Int): LoggingBehavior {
        return when (value) {
            0 -> LoggingBehavior.REQUESTS
            1 -> LoggingBehavior.INCLUDE_ACCESS_TOKENS
            2 -> LoggingBehavior.INCLUDE_RAW_RESPONSES
            3 -> LoggingBehavior.CACHE
            4 -> LoggingBehavior.APP_EVENTS
            5 -> LoggingBehavior.DEVELOPER_ERRORS
            6 -> LoggingBehavior.GRAPH_API_DEBUG_WARNING
            7 -> LoggingBehavior.GRAPH_API_DEBUG_INFO
            else -> LoggingBehavior.REQUESTS
        }
    }

    // Share
    fun onShareSuccess(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        onShareSuccessEventId = String(argv[0])
        return null
    }

    fun onShareCancel(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        onShareCancelEventId = String(argv[0])
        return null
    }

    fun onShareError(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        onShareErrorEventId = String(argv[0])
        return null
    }

    private fun createSharingContent(freObject: FREObject?): ShareContent<out ShareContent<*, *>, out ShareContent.Builder<*, *>>? {
        when (freObject.className?.splitToSequence("::")?.last() ?: return null) {
            "ShareLinkContent" -> return ShareLinkContent(freObject)
            "SharePhotoContent" -> return SharePhotoContent(freObject)
            "ShareVideoContent" -> return ShareVideoContent(freObject)
        }
        return null
    }

    fun shareDialog_create(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = UUID.randomUUID().toString()
        val dialog = ShareDialog(activity)
        dialog.registerCallback(callbackManager, ResultFacebookCallback(dialog))
        shareDialogs[id] = dialog
        return id.toFREObject()
    }

    fun shareDialog_show(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val content = createSharingContent(argv[1]) ?: return null
        shareDialogs[id]?.show(content)
        return null
    }

    fun shareDialog_canShow(ctx: FREContext, argv: FREArgv): FREObject? {
        return ShareDialog.canShow(ShareLinkContent::class.java).toFREObject()
    }

    fun messageDialog_create(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = UUID.randomUUID().toString()
        val dialog = MessageDialog(activity)
        dialog.registerCallback(callbackManager, ResultFacebookCallback(dialog))
        messageDialogs[id] = dialog
        return id.toFREObject()
    }

    fun messageDialog_show(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val content = createSharingContent(argv[1]) ?: return null
        messageDialogs[id]?.show(content)
        return null
    }

    fun messageDialog_canShow(ctx: FREContext, argv: FREArgv): FREObject? {
        return MessageDialog.canShow(ShareLinkContent::class.java).toFREObject()
    }

    fun shareAPI_create(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val content = createSharingContent(argv[1]) ?: return null
        val id = UUID.randomUUID().toString()
        val api = ShareApi(content)
        shareAPIs[id] = api
        return id.toFREObject()
    }

    fun shareAPI_share(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        shareAPIs[id]?.share(ResultFacebookCallback(null))
        return null
    }

    fun shareAPI_canShare(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        return shareAPIs[id]?.canShare()?.toFREObject()
    }


    inner class ResultFacebookCallback(private val dialog: FacebookDialogBase<ShareContent<*, *>, Sharer.Result>?) : FacebookCallback<Sharer.Result> {
        override fun onSuccess(result: Sharer.Result?) {
            if (onShareSuccessEventId != null) {
                dispatchEvent(FacebookEvent.ON_SHARE_SUCCESS,
                        Gson().toJson(FacebookEvent(onShareSuccessEventId,
                                mapOf("postId" to result?.postId)))
                )
            }
            dialog?.registerCallback(callbackManager, null)
        }

        override fun onCancel() {
            if (onShareCancelEventId != null) {
                dispatchEvent(FacebookEvent.ON_SHARE_CANCEL,
                        Gson().toJson(FacebookEvent(onShareCancelEventId))
                )
            }
            dialog?.registerCallback(callbackManager, null)
        }

        override fun onError(error: FacebookException?) {
            if (onShareErrorEventId != null) {
                dispatchEvent(FacebookEvent.ON_SHARE_ERROR,
                        Gson().toJson(FacebookEvent(onShareErrorEventId,
                                mapOf("message" to error?.localizedMessage))
                        )
                )
            }
            dialog?.registerCallback(callbackManager, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        callbackManager?.onActivityResult(requestCode, resultCode, intent)
    }

    override fun onConfigurationChanged(configuration: Configuration?) {
    }

    override fun onActivityStateChanged(activityState: AndroidActivityWrapper.ActivityState?) {

    }

    override val TAG: String?
        get() = this::class.java.simpleName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }
}