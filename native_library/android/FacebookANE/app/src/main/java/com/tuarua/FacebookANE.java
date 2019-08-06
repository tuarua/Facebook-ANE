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
package com.tuarua;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tuarua.facebookane.KotlinController;

@SuppressWarnings({"WeakerAccess", "unused"})
public class FacebookANE implements FREExtension {
    private String NAME = "com.tuarua.FacebookANE";
    private static final String[] FUNCTIONS = {
             "init"
            ,"createGUID"
            ,"setIsDebugEnabled"
            ,"addLoggingBehavior"
            ,"removeLoggingBehavior"
            ,"clearLoggingBehaviors"
            ,"isLoggingBehaviorEnabled"
            ,"getLimitEventAndDataUsage"
            ,"setLimitEventAndDataUsage"
            ,"isDebugEnabled"
            ,"getHashKey"
            ,"isInitialized"
            ,"login"
            ,"logout"
            ,"getLoginBehavior"
            ,"setLoginBehavior"
            ,"getDefaultAudience"
            ,"setDefaultAudience"
            ,"getCurrentAccessToken"
            ,"refreshCurrentAccessTokenAsync"
            ,"isCurrentAccessTokenActive"
            ,"isDataAccessActive"
            ,"shareDialog_create"
            ,"shareDialog_show"
            ,"shareDialog_canShow"
            ,"messageDialog_create"
            ,"messageDialog_show"
            ,"messageDialog_canShow"
            ,"shareAPI_create"
            ,"shareAPI_share"
            ,"shareAPI_canShare"
            ,"setIsAdvertiserIDCollectionEnabled"
            ,"setIsAutoLogAppEventsEnabled"
            ,"getSdkVersion"
    };
    public static FacebookANEContext extensionContext;

    @Override
    public void initialize() {

    }

    @Override
    public FREContext createContext(String s) {
        return extensionContext = new FacebookANEContext(NAME, new KotlinController(), FUNCTIONS);
    }

    @Override
    public void dispose() {
        extensionContext.dispose();
    }
}
