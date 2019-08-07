/* Copyright 2019 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
import Foundation
import FreSwift

import FacebookCore
import FBSDKCoreKit

extension SwiftController: FreSwiftMainController {
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)createGUID"] = createGUID
        functionsToSet["\(prefix)setIsDebugEnabled"] = setIsDebugEnabled
        functionsToSet["\(prefix)addLoggingBehavior"] = addLoggingBehavior
        functionsToSet["\(prefix)removeLoggingBehavior"] = removeLoggingBehavior
        functionsToSet["\(prefix)clearLoggingBehaviors"] = clearLoggingBehaviors
        functionsToSet["\(prefix)isLoggingBehaviorEnabled"] = isLoggingBehaviorEnabled
        functionsToSet["\(prefix)getLimitEventAndDataUsage"] = getLimitEventAndDataUsage
        functionsToSet["\(prefix)setLimitEventAndDataUsage"] = setLimitEventAndDataUsage
        functionsToSet["\(prefix)isDebugEnabled"] = isDebugEnabled
        functionsToSet["\(prefix)getHashKey"] = getHashKey
        functionsToSet["\(prefix)isInitialized"] = isInitialized
        functionsToSet["\(prefix)login"] = login
        functionsToSet["\(prefix)logout"] = logout
        functionsToSet["\(prefix)getLoginBehavior"] = getLoginBehavior
        functionsToSet["\(prefix)setLoginBehavior"] = setLoginBehavior
        functionsToSet["\(prefix)getDefaultAudience"] = getDefaultAudience
        functionsToSet["\(prefix)setDefaultAudience"] = setDefaultAudience
        functionsToSet["\(prefix)getCurrentAccessToken"] = getCurrentAccessToken
        functionsToSet["\(prefix)refreshCurrentAccessTokenAsync"] = refreshCurrentAccessTokenAsync
        functionsToSet["\(prefix)isCurrentAccessTokenActive"] = isCurrentAccessTokenActive
        functionsToSet["\(prefix)isDataAccessActive"] = isDataAccessActive
        functionsToSet["\(prefix)shareDialog_create"] = shareDialog_create
        functionsToSet["\(prefix)shareDialog_show"] = shareDialog_show
        functionsToSet["\(prefix)shareDialog_canShow"] = shareDialog_canShow
        functionsToSet["\(prefix)messageDialog_create"] = messageDialog_create
        functionsToSet["\(prefix)messageDialog_show"] = messageDialog_show
        functionsToSet["\(prefix)messageDialog_canShow"] = messageDialog_canShow
        functionsToSet["\(prefix)shareAPI_create"] = shareAPI_create
        functionsToSet["\(prefix)shareAPI_share"] = shareAPI_share
        functionsToSet["\(prefix)shareAPI_canShare"] = shareAPI_canShare
        functionsToSet["\(prefix)setIsAdvertiserIDCollectionEnabled"] = setIsAdvertiserIDCollectionEnabled
        functionsToSet["\(prefix)setIsAutoLogAppEventsEnabled"] = setIsAutoLogAppEventsEnabled
        functionsToSet["\(prefix)getSdkVersion"] = getSdkVersion
        functionsToSet["\(prefix)onShareSuccess"] = onShareSuccess
        functionsToSet["\(prefix)onShareCancel"] = onShareCancel
        functionsToSet["\(prefix)onShareError"] = onShareError

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        self.appDidFinishLaunchingNotification = notification
    }
    
    @objc func applicationDidBecomeActive(_ notification: Notification) {
        AppEvents.activateApp()
    }
    
    @objc public func dispose() {
        NotificationCenter.default.removeObserver(self)
        // Add other clean up code here
    }
    
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift(freContext: ctx)
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
}
