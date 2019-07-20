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
public final class LoginBehavior {
    /**
     * Specifies that login should attempt login in using the Facebook App, and if that
     * does not work fall back to web dialog auth. This is the default behavior.
     */
    public static const NATIVE_WITH_FALLBACK:int = 0;
    /**
     * Specifies that login should only attempt to login using the Facebook App.
     * If the Facebook App cannot be used then the login fails.
     */
    public static const NATIVE_ONLY:int = 1;
    /**
     * Specifies that login should only attempt to use Katana Proxy Login.
     */
    public static const KATANA_ONLY:int = 2;
    /**
     * Specifies that only the web dialog auth should be used.
     */
    public static const WEB_ONLY:int = 3;
    /**
     * Specifies that only the web view dialog auth should be used.
     */
    public static const WEB_VIEW_ONLY:int = 4;
    /**
     * Specifies that only the web dialog auth (from anywhere) should be used
     */
    public static const DIALOG_ONLY:int = 5;
//    public static const DEVICE_AUTH:int = 6;

}
}
