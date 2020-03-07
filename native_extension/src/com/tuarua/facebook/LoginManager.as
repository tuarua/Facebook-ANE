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
package com.tuarua.facebook {
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;

public class LoginManager {
    /** @private */
    public function LoginManager() {
    }

    public function login(permissions:Vector.<String>, onSuccess:Function, onCancel:Function, onError:Function,
                          withPublish:Boolean = false):void {
        var ret:* = FacebookANEContext.context.call("login", permissions, withPublish,
                FacebookANEContext.createCallback(onSuccess),
                FacebookANEContext.createCallback(onCancel),
                FacebookANEContext.createCallback(onError));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Logs out the user.
     */
    public function logout():void {
        var ret:* = FacebookANEContext.context.call("logout");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Getter for the login behavior.
     * @return the login behavior.
     */
    public function get loginBehavior():int {
        var ret:* = FacebookANEContext.context.call("getLoginBehavior");
        if (ret is ANEError) throw ret as ANEError;
        return int(ret);
    }

    /**
     * Setter for the login behavior.
     * @param loginBehavior The login behavior.
     */
    public function set loginBehavior(loginBehavior:int):void {
        var ret:* = FacebookANEContext.context.call("setLoginBehavior", loginBehavior);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Getter for the default audience.
     * @return The default audience.
     */
    public function get defaultAudience():int {
        var ret:* = FacebookANEContext.context.call("getDefaultAudience");
        if (ret is ANEError) throw ret as ANEError;
        return int(ret);
    }

    /**
     * Setter for the default audience.
     * @param defaultAudience The default audience.
     */
    public function set defaultAudience(defaultAudience:int):void {
        var ret:* = FacebookANEContext.context.call("setDefaultAudience", defaultAudience);
        if (ret is ANEError) throw ret as ANEError;
    }

}
}