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
import com.tuarua.facebook.ShareLinkContent;
import com.tuarua.fre.ANEError;

public class FacebookANE {
    /** @private */
    private static var _loginManager:LoginManager;

    public static function init(applicationId:String, onCurrentAccessTokenChanged:Function = null):void {
        if (FacebookANEContext.context) {
            var theRet:* = FacebookANEContext.context.call("init", applicationId,
                    FacebookANEContext.createEventId(onCurrentAccessTokenChanged));
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /**
     * Used to enable or disable logging, and other debug features. Defaults to BuildConfig.DEBUG.
     * @param value Debug features (like logging) are enabled if true, disabled if false.
     */
    public static function set isDebugEnabled(value:Boolean):void {
        var theRet:* = FacebookANEContext.context.call("setIsDebugEnabled", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Indicates if we are in debug mode.
     */
    public static function get isDebugEnabled():Boolean {
        var theRet:* = FacebookANEContext.context.call("isDebugEnabled");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
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
        var theRet:* = FacebookANEContext.context.call("addLoggingBehavior", behavior);
        if (theRet is ANEError) throw theRet as ANEError;
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
        var theRet:* = FacebookANEContext.context.call("removeLoggingBehavior", behavior);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Certain logging behaviors are available for debugging beyond those that should be
     * enabled in production.
     *
     * Disables all extended logging behaviors.
     */
    public static function clearLoggingBehaviors():void {
        var theRet:* = FacebookANEContext.context.call("clearLoggingBehaviors");
        if (theRet is ANEError) throw theRet as ANEError;
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
        var theRet:* = FacebookANEContext.context.call("isLoggingBehaviorEnabled", behavior);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    /**
     * Returns whether data such as those generated through AppEventsLogger and sent to Facebook
     * should be restricted from being used for purposes other than analytics and conversions, such
     * as targeting ads to this user.  Defaults to false.  This value is stored on the device and
     * persists across app launches.
     *
     */
    public static function get limitEventAndDataUsage():Boolean {
        var theRet:* = FacebookANEContext.context.call("getLimitEventAndDataUsage");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
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
        var theRet:* = FacebookANEContext.context.call("setLimitEventAndDataUsage", value);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get hashKey():String {
        var theRet:* = FacebookANEContext.context.call("getHashKey");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as String;
    }

    /**
     * Indicates whether the Facebook SDK has been initialized.
     */
    public static function get isInitialized():Boolean {
        var theRet:* = FacebookANEContext.context.call("isInitialized");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    public static function share(shareLinkContent:ShareLinkContent, onSuccess:Function,
                                 onCancel:Function, onError:Function, dialogType:uint = 0):void {
        var theRet:* = FacebookANEContext.context.call("share", shareLinkContent, dialogType,  
                FacebookANEContext.createEventId(onSuccess),
                FacebookANEContext.createEventId(onCancel),
                FacebookANEContext.createEventId(onError));
        if (theRet is ANEError) throw theRet as ANEError;
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

    /** Disposes the ANE */
    public static function dispose():void {
        if (FacebookANEContext.context) {
            FacebookANEContext.dispose();
        }
    }

}
}