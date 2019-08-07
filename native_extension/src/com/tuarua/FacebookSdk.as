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
package com.tuarua {
import com.tuarua.facebook.LoginManager;
import com.tuarua.fre.ANEError;

public class FacebookSdk {
    /** @private */
    private static var _loginManager:LoginManager;
    private static var _isAdvertiserIDCollectionEnabled:Boolean = true;
    private static var _isAutoLogAppEventsEnabled:Boolean = true;
    private static var _inited:Boolean = false;

    /**
     * @param applicationId 
     * @param onCurrentAccessTokenChanged doesn't fire on iOS 
     */
    public static function init(applicationId:String, onCurrentAccessTokenChanged:Function = null):void {
        if (FacebookANEContext.context) {
            var ret:* = FacebookANEContext.context.call("init", applicationId,
                    FacebookANEContext.createEventId(onCurrentAccessTokenChanged),
                    _isAdvertiserIDCollectionEnabled,
                    _isAutoLogAppEventsEnabled);
            if (ret is ANEError) throw ret as ANEError;
            _inited = true
        }
    }

    /**
     * Used to enable or disable logging, and other debug features. Defaults to BuildConfig.DEBUG.
     * @param value Debug features (like logging) are enabled if true, disabled if false.
     */
    public static function set isDebugEnabled(value:Boolean):void {
        var ret:* = FacebookANEContext.context.call("setIsDebugEnabled", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Indicates if we are in debug mode.
     */
    public static function get isDebugEnabled():Boolean {
        var ret:* = FacebookANEContext.context.call("isDebugEnabled");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Certain logging behaviors are available for debugging beyond those that should be
     * enabled in production.
     *
     * Enables a particular extended logging in the SDK.
     *
     * @param behavior The LoggingBehavior to enable
     */
    public static function addLoggingBehavior(behavior:int):void {
        var ret:* = FacebookANEContext.context.call("addLoggingBehavior", behavior);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Certain logging behaviors are available for debugging beyond those that should be
     * enabled in production.
     *
     * Disables a particular extended logging behavior in the SDK.
     *
     * @param behavior The LoggingBehavior to disable
     */
    public static function removeLoggingBehavior(behavior:int):void {
        var ret:* = FacebookANEContext.context.call("removeLoggingBehavior", behavior);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Certain logging behaviors are available for debugging beyond those that should be
     * enabled in production.
     *
     * Disables all extended logging behaviors.
     */
    public static function clearLoggingBehaviors():void {
        var ret:* = FacebookANEContext.context.call("clearLoggingBehaviors");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Certain logging behaviors are available for debugging beyond those that should be
     * enabled in production.
     *
     * Checks if a particular extended logging behavior is enabled.
     *
     * @param behavior The LoggingBehavior to check
     * @return whether behavior is enabled
     */
    public static function isLoggingBehaviorEnabled(behavior:int):Boolean {
        var ret:* = FacebookANEContext.context.call("isLoggingBehaviorEnabled", behavior);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Returns whether data such as those generated through AppEventsLogger and sent to Facebook
     * should be restricted from being used for purposes other than analytics and conversions, such
     * as targeting ads to this user.  Defaults to false.  This value is stored on the device and
     * persists across app launches.
     *
     */
    public static function get limitEventAndDataUsage():Boolean {
        var ret:* = FacebookANEContext.context.call("getLimitEventAndDataUsage");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Sets whether data such as those generated through AppEventsLogger and sent to Facebook should
     * be restricted from being used for purposes other than analytics and conversions, such as
     * targeting ads to this user.  Defaults to false.  This value is stored on the device and
     * persists across app launches.  Changes to this setting will apply to app events currently
     * queued to be flushed.
     *
     */
    public static function set limitEventAndDataUsage(value:Boolean):void {
        var ret:* = FacebookANEContext.context.call("setLimitEventAndDataUsage", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    public static function get hashKey():String {
        var ret:* = FacebookANEContext.context.call("getHashKey");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /**
     * Indicates whether the Facebook SDK has been initialized.
     */
    public static function get isInitialized():Boolean {
        var ret:* = FacebookANEContext.context.call("isInitialized");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Getter for the login manager.
     * @return The login manager.
     */
    public static function get loginManager():LoginManager {
        if (_loginManager == null) {
            _loginManager = new LoginManager();
        }
        return _loginManager;
    }

    public static function set onShareSuccess(value:Function):void {
        var ret:* = FacebookANEContext.context.call("onShareSuccess", FacebookANEContext.createEventId(value));
        if (ret is ANEError) throw ret as ANEError;
    }

    public static function set onShareCancel(value:Function):void {
        var ret:* = FacebookANEContext.context.call("onShareCancel", FacebookANEContext.createEventId(value));
        if (ret is ANEError) throw ret as ANEError;
    }

    public static function set onShareError(value:Function):void {
        var ret:* = FacebookANEContext.context.call("onShareError", FacebookANEContext.createEventId(value));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Controls the fb_codeless_debug logging event If not explicitly set, the default is true */
    public static function set isAdvertiserIDCollectionEnabled(value:Boolean):void {
        _isAdvertiserIDCollectionEnabled = value;
        if (!_inited) return;
        var ret:* = FacebookANEContext.context.call("setIsAdvertiserIDCollectionEnabled", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Controls the auto logging of basic app events, such as activateApp and deactivateApp. If not explicitly set, the default is true */
    public static function set isAutoLogAppEventsEnabled(value:Boolean):void {
        _isAutoLogAppEventsEnabled = value;
        if (!_inited) return;
        var ret:* = FacebookANEContext.context.call("setIsAutoLogAppEventsEnabled", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Retrieve the current SDK version. */
    public static function get sdkVersion():String {
        var ret:* = FacebookANEContext.context.call("getSdkVersion");
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (FacebookANEContext.context) {
            FacebookANEContext.dispose();
        }
    }

}
}