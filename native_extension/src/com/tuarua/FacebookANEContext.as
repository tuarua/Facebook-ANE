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
    public static var closures:Dictionary = new Dictionary();

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

    public static function createEventId(listener:Function):String {
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        var closure:Function;
        // trace(event.code);
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case ON_TOKEN_REFRESH:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, new AccessToken(argsAsJSON.data));
                delete closures[argsAsJSON.eventId];
                break;
            case ON_CURRENT_ACCESS_TOKEN_CHANGED:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, new AccessToken(argsAsJSON.data.oldToken),
                        new AccessToken(argsAsJSON.data.newToken));
                delete closures[argsAsJSON.eventId];
                break;
            case ON_TOKEN_REFRESH_FAILED:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, new FacebookError(argsAsJSON.data.message));
                delete closures[argsAsJSON.eventId];
                break;
            case ON_LOGIN_CANCEL:
            case ON_SHARE_CANCEL:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null);
                delete closures[argsAsJSON.eventId];
                break;
            case ON_LOGIN_ERROR:
            case ON_SHARE_ERROR:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, new FacebookError(argsAsJSON.data.message));
                delete closures[argsAsJSON.eventId];
                break;
            case ON_LOGIN_SUCCESS:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, new LoginResult(argsAsJSON.data));
                delete closures[argsAsJSON.eventId];
                break;
            case ON_SHARE_SUCCESS:
                argsAsJSON = JSON.parse(event.code);
                closure = closures[argsAsJSON.eventId];
                if (closure == null) return;
                closure.call(null, argsAsJSON.data.postId);
                delete closures[argsAsJSON.eventId];
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
