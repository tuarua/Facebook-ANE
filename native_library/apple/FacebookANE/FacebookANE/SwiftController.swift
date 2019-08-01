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
import FacebookLogin

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func setIsDebugEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("isDebugEnabled is not implemented in the iOS version")
        return nil
    }
    
    func isDebugEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("isDebugEnabled is not implemented in the iOS version")
        return false.toFREObject()
    }
    
    func addLoggingBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "addLoggingBehavior").getError(#file, #line, #column)
        }
        SDKSettings.enableLoggingBehavior(loggingBehaviorFromInt(behaviour))
        return nil
    }
    
    func removeLoggingBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "removeLoggingBehavior").getError(#file, #line, #column)
        }
        SDKSettings.disableLoggingBehavior(loggingBehaviorFromInt(behaviour))
        return nil
    }
    
    func clearLoggingBehaviors(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        for loginBehaviour in SDKSettings.enabledLoggingBehaviors {
            SDKSettings.disableLoggingBehavior(loginBehaviour)
        }
        return nil
    }
    
    func isLoggingBehaviorEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "isLoggingBehaviorEnabled").getError(#file, #line, #column)
        }
        trace("looking for \(behaviour)")
        for loginBehaviour in SDKSettings.enabledLoggingBehaviors {
            trace(loginBehaviour.hashValue)
        }
        
        return nil
    }
    
    func loggingBehaviorFromInt(_ value: Int) -> SDKLoggingBehavior {
        switch value {
        case 0:
            return SDKLoggingBehavior.networkRequests
        case 1:
            return SDKLoggingBehavior.accessTokens
        case 3:
            return SDKLoggingBehavior.cacheErrors
        case 4:
            return SDKLoggingBehavior.appEvents
        case 5:
            return SDKLoggingBehavior.developerErrors
        case 6:
            return SDKLoggingBehavior.graphAPIDebugWarning
        case 7:
            return SDKLoggingBehavior.graphAPIDebugInfo
        default:
            return SDKLoggingBehavior.networkRequests
        }
    }
    
    /*
     TODO what is raw equiv - add iOS specific
        0 -> LoggingBehavior.REQUESTS
        1 -> LoggingBehavior.INCLUDE_ACCESS_TOKENS
     2 -> LoggingBehavior.INCLUDE_RAW_RESPONSES
        3 -> LoggingBehavior.CACHE
        4 -> LoggingBehavior.APP_EVENTS
        5 -> LoggingBehavior.DEVELOPER_ERRORS
        6 -> LoggingBehavior.GRAPH_API_DEBUG_WARNING
        7 -> LoggingBehavior.GRAPH_API_DEBUG_INFO
     else -> LoggingBehavior.REQUESTS
 */
    
    func getLimitEventAndDataUsage(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return SDKSettings.limitedEventAndDataUsage.toFREObject()
    }
    
    func setLimitEventAndDataUsage(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        SDKSettings.limitedEventAndDataUsage = Bool(argv[0]) == true
        return nil
    }
    
    func getHashKey(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("hashKey is not implemented in the iOS version")
        return nil
    }
    
    func isInitialized(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    // MARK: - LoginManager
    
    func login(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let permissions = [String](argv[0]),
            let withPublish = Bool(argv[1]),
            let onSuccessEventId = String(argv[2]),
            let onCancelEventId = String(argv[3]),
            let onErrorEventId = String(argv[4])
            else {
                return FreArgError(message: "login").getError(#file, #line, #column)
        }
        let loginManager = LoginManager()
        
        trace("PublishPermission.publishPages \(PublishPermission.publishPages)")
        trace("ReadPermission.publicProfile \(ReadPermission.publicProfile)")
        
        if withPublish {
            loginManager.logIn(publishPermissions: [PublishPermission.publishPages],
                               viewController: UIApplication.shared.keyWindow?.rootViewController) { loginResult in
                switch loginResult {
                case .failed(let error):
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_ERROR, eventId: onErrorEventId, error: error, data: nil)
                case .cancelled:
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_CANCEL, eventId: onCancelEventId, error: nil, data: nil)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    self.trace(grantedPermissions)
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_SUCCESS, eventId: onSuccessEventId, error: nil,
                                            data: ["accessToken": accessToken.toDictionary(), "recentlyGrantedPermissions":
                                                grantedPermissions, "recentlyDeniedPermissions": declinedPermissions])
                }
            }
        } else {
            loginManager.logIn(readPermissions: [.email],
                               viewController: UIApplication.shared.keyWindow?.rootViewController) { loginResult in
                switch loginResult {
                case .failed(let error):
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_ERROR, eventId: onErrorEventId, error: error, data: nil)
                case .cancelled:
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_CANCEL, eventId: onCancelEventId, error: nil, data: nil)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    self.trace("Logged in!")
                    self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_SUCCESS, eventId: onSuccessEventId, error: nil,
                                            data: ["accessToken": accessToken.toDictionary(), "recentlyGrantedPermissions":
                                                grantedPermissions, "recentlyDeniedPermissions": declinedPermissions])
                }
            }
        }
        return nil
    }
    
    func dispatchLoginEvent(name: String, eventId: String, error: Error?, data: [String: Any]?) {
        var props = [String: Any]()
        props["eventId"] = eventId
        if let err = error {
            props["data"] = ["message": err.localizedDescription]
        }
        if let data = data {
            props["data"] = data
        }
        self.dispatchEvent(name: name, value: JSON(props).description)
    }
    
    func logout(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let loginManager = LoginManager()
        loginManager.logOut()
        return nil
    }
    
    func getLoginBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let loginManager = LoginManager()
        switch loginManager.loginBehavior {
        case .native:
            return 0.toFREObject()
        case .browser:
            return 3.toFREObject()
        case .web:
            return 4.toFREObject()
        case .systemAccount:
            return 7.toFREObject()
        }
    }
    
    func setLoginBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let loginBehavior = Int(argv[0])
            else {
                return FreArgError(message: "setLoginBehavior").getError(#file, #line, #column)
        }
        let loginManager = LoginManager()
        switch loginBehavior {
        case 0:
            loginManager.loginBehavior = .native
        case 3:
            loginManager.loginBehavior = .browser
        case 4:
            loginManager.loginBehavior = .web
        case 7:
            loginManager.loginBehavior = .systemAccount
        default:
            break
        }
        return nil
    }
    
    func getDefaultAudience(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let loginManager = LoginManager()
        switch loginManager.defaultAudience {
        case .onlyMe:
            return 1.toFREObject()
        case .friends:
            return 2.toFREObject()
        case .everyone:
            return 3.toFREObject()
        }
    }
    
    func setDefaultAudience(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let defaultAudience = Int(argv[0])
            else {
                return FreArgError(message: "setDefaultAudience").getError(#file, #line, #column)
        }
        let loginManager = LoginManager()
        switch defaultAudience {
        case 1:
            loginManager.defaultAudience = .onlyMe
        case 2:
            loginManager.defaultAudience = .friends
        case 3:
            loginManager.defaultAudience = .everyone
        default:
            break
        }
        return nil
    }
    
    // MARK: - AccessToken
    
    func getCurrentAccessToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let accessToken = AccessToken.current {
            return JSON(accessToken.toDictionary()).description.toFREObject()
        }
        return nil
    }
    
    func refreshCurrentAccessTokenAsync(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let onTokenRefreshedEventId = String(argv[0]),
            let onTokenRefreshFailedEventId = String(argv[1])
            else {
                return FreArgError(message: "setDefaultAudience").getError(#file, #line, #column)
        }
        AccessToken.refreshCurrentToken { accessToken, error in
            var props = [String: Any]()
            if let err = error {
                props["eventId"] = onTokenRefreshFailedEventId
                props["data"] = ["message": err.localizedDescription]
                self.dispatchEvent(name: FacebookEvent.ON_TOKEN_REFRESH_FAILED, value: JSON(props).description)
            } else {
                props["eventId"] = onTokenRefreshedEventId
                if let accessToken = accessToken {
                    props["data"] = accessToken.toDictionary()
                }
                self.dispatchEvent(name: FacebookEvent.ON_TOKEN_REFRESH, value: JSON(props).description)
            }
        }
        return nil
    }
    
    func isCurrentAccessTokenActive(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        /*
         final AccessToken accessToken = AccessTokenManager.getInstance().getCurrentAccessToken();
         return accessToken != null && !accessToken.isExpired();
         */
        if let expirationDate = AccessToken.current?.expirationDate, expirationDate > Date() {
            return true.toFREObject()
        }
        return false.toFREObject()
    }
    
    func isDataAccessActive(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let _ = AccessToken.current {
            return true.toFREObject()
        }
        /*
         final AccessToken accessToken = AccessTokenManager.getInstance().getCurrentAccessToken();
         return accessToken != null && !accessToken.isDataAccessExpired();
         */
        return false.toFREObject()
    }
    
    // MARK: - Share
    
    func share(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("TODO share")
        return nil
    }

}
