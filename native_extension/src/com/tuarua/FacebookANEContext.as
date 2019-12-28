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
import com.tuarua.facebook.AccessToken;
import com.tuarua.facebook.FacebookError;
import com.tuarua.facebook.LoginResult;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class FacebookANEContext {
    internal static const NAME:String = "FacebookANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    private static var _isDisposed:Boolean;
    private static var argsAsJSON:Object;
    public static var callbacks:Dictionary = new Dictionary();

    private static const ON_TOKEN_REFRESH:String = "FacebookEvent.OnTokenRefresh";
    private static const ON_TOKEN_REFRESH_FAILED:String = "FacebookEvent.OnTokenRefreshFailed";
    private static const ON_CURRENT_ACCESS_TOKEN_CHANGED:String = "FacebookEvent.onCurrentAccessTokenChanged";
    private static const ON_LOGIN_SUCCESS:String = "FacebookEvent.OnLoginSuccess";
    private static const ON_LOGIN_CANCEL:String = "FacebookEvent.OnLoginCancel";
    private static const ON_LOGIN_ERROR:String = "FacebookEvent.OnLoginError";
    private static const ON_SHARE_SUCCESS:String = "FacebookEvent.OnShareSuccess";
    private static const ON_SHARE_CANCEL:String = "FacebookEvent.OnShareCancel";
    private static const ON_SHARE_ERROR:String = "FacebookEvent.OnShareError";

    public function FacebookANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isDisposed = false;
            } catch (e:Error) {
                throw new Error("ANE " + NAME + " not created properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    private static function callCallback(callbackId:String, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case ON_TOKEN_REFRESH:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new AccessToken(argsAsJSON.data));
                break;
            case ON_CURRENT_ACCESS_TOKEN_CHANGED:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new AccessToken(argsAsJSON.data.oldToken),
                        new AccessToken(argsAsJSON.data.newToken));
                break;
            case ON_TOKEN_REFRESH_FAILED:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new FacebookError(argsAsJSON.data.message));
                break;
            case ON_LOGIN_CANCEL:
            case ON_SHARE_CANCEL:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId);
                break;
            case ON_LOGIN_ERROR:
            case ON_SHARE_ERROR:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new FacebookError(argsAsJSON.data.message));
                break;
            case ON_LOGIN_SUCCESS:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new LoginResult(argsAsJSON.data));
                break;
            case ON_SHARE_SUCCESS:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, argsAsJSON.data.postId);
                break;
        }
    }

    public static function dispose():void {
        if (_context == null) return;
        _isDisposed = true;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }

    public static function get isDisposed():Boolean {
        return _isDisposed;
    }
}
}
