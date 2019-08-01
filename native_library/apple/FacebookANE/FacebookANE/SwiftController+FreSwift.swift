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
        functionsToSet["\(prefix)share"] = share

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        // notification.userInfo
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
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
}
