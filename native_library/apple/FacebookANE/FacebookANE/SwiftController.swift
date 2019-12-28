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
import FacebookShare
import SwiftyJSON

public class SwiftController: NSObject, SharingDelegate {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    internal var appDidFinishLaunchingNotification: Notification?
    internal var onShareSuccessCallbackId: String?
    internal var onShareCancelCallbackId: String?
    internal var onShareErrorCallbackId: String?
    private var shareDialogs = [String: ShareDialog]()
    private var messageDialogs = [String: MessageDialog]()
    private var shareAPIs = [String: ShareAPI]()
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let applicationId = String(argv[0]),
            let isAdvertiserIDCollectionEnabled = Bool(argv[2]),
            let isAutoLogAppEventsEnabled = Bool(argv[3])
            else {
                return FreArgError(message: "initController").getError(#file, #line, #column)
        }
        if let appDidFinishLaunchingNotification = appDidFinishLaunchingNotification,
            let application = appDidFinishLaunchingNotification.object as? UIApplication {
            ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: appDidFinishLaunchingNotification.userInfo as? [UIApplication.LaunchOptionsKey: Any])
        }
        Settings.appID = applicationId
        Settings.isAdvertiserIDCollectionEnabled = isAdvertiserIDCollectionEnabled
        Settings.isAutoLogAppEventsEnabled = isAutoLogAppEventsEnabled
        return true.toFREObject()
    }
    
    // MARK: - Settings
    
    func setIsDebugEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        Settings.isCodelessDebugLogEnabled = Bool(argv[0]) == true
        return nil
    }
    
    func isDebugEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return Settings.isCodelessDebugLogEnabled.toFREObject()
    }
    
    func addLoggingBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "addLoggingBehavior").getError(#file, #line, #column)
        }
        Settings.enableLoggingBehavior(loggingBehaviorFromInt(behaviour))
        return nil
    }
    
    func removeLoggingBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "removeLoggingBehavior").getError(#file, #line, #column)
        }
        Settings.disableLoggingBehavior(loggingBehaviorFromInt(behaviour))
        return nil
    }
    
    func clearLoggingBehaviors(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        for loginBehaviour in Settings.loggingBehaviors {
            Settings.disableLoggingBehavior(loginBehaviour)
        }
        return nil
    }
    
    func isLoggingBehaviorEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let behaviour = Int(argv[0])
            else {
                return FreArgError(message: "isLoggingBehaviorEnabled").getError(#file, #line, #column)
        }
        for loginBehaviour in Settings.loggingBehaviors {
            if loggingBehaviorFromInt(behaviour) == loginBehaviour {
                return true.toFREObject()
            }
        }
        return false.toFREObject()
    }
    
    func loggingBehaviorFromInt(_ value: Int) -> LoggingBehavior {
        switch value {
        case 0:
            return LoggingBehavior.networkRequests
        case 1:
            return LoggingBehavior.accessTokens
        case 3:
            return LoggingBehavior.cacheErrors
        case 4:
            return LoggingBehavior.appEvents
        case 5:
            return LoggingBehavior.developerErrors
        case 6:
            return LoggingBehavior.graphAPIDebugWarning
        case 7:
            return LoggingBehavior.graphAPIDebugInfo
        case 8:
            return LoggingBehavior.uiControlErrors
        case 9:
            return LoggingBehavior.performanceCharacteristics
        case 10:
            return LoggingBehavior.informational
        default:
            return LoggingBehavior.networkRequests
        }
    }
    
    func getLimitEventAndDataUsage(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return Settings.shouldLimitEventAndDataUsage.toFREObject()
    }
    
    func setLimitEventAndDataUsage(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        Settings.shouldLimitEventAndDataUsage = Bool(argv[0]) == true
        return nil
    }
    
    func getHashKey(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("hashKey is not implemented in the iOS version")
        return nil
    }
    
    func isInitialized(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func setIsAdvertiserIDCollectionEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        Settings.isAdvertiserIDCollectionEnabled = Bool(argv[0]) == true
        return nil
    }
    
    func setIsAutoLogAppEventsEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        Settings.isAutoLogAppEventsEnabled = Bool(argv[0]) == true
        return nil
    }
    
    func getSdkVersion(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return Settings.sdkVersion.toFREObject()
    }
    
    // MARK: - LoginManager
    
    func login(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let permissions = [String](argv[0]),
            let onSuccessCallbackId = String(argv[2]),
            let onCancelCallbackId = String(argv[3]),
            let onErrorCallbackId = String(argv[4])
            else {
                return FreArgError(message: "login").getError(#file, #line, #column)
        }
        let loginManager = LoginManager()
        loginManager.logIn(permissions: permissions.compactMap { Permission(stringLiteral: $0) },
                           viewController: UIApplication.shared.keyWindow?.rootViewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_ERROR, callbackId: onErrorCallbackId, error: error, data: nil)
            case .cancelled:
                self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_CANCEL, callbackId: onCancelCallbackId, error: nil, data: nil)
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.dispatchLoginEvent(name: FacebookEvent.ON_LOGIN_SUCCESS, callbackId: onSuccessCallbackId, error: nil,
                                        data: ["accessToken": accessToken.toDictionary(),
                                               "recentlyGrantedPermissions": grantedPermissions.compactMap { $0.name },
                                               "recentlyDeniedPermissions": declinedPermissions.compactMap { $0.name }])
            }
        }
        return nil
    }
    
    func dispatchLoginEvent(name: String, callbackId: String, error: Error?, data: [String: Any]?) {
        var props = [String: Any]()
        props["callbackId"] = callbackId
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
        warning("loginBehavior is always BROWSER in the iOS version")
        return 3.toFREObject()
    }
    
    func setLoginBehavior(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("loginBehavior is always BROWSER in the iOS version")
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
        @unknown default:
            return 1.toFREObject()
        }
    }
    
    func setDefaultAudience(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let defaultAudience = UInt(argv[0])
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
            let onTokenRefreshedCallbackId = String(argv[0]),
            let onTokenRefreshFailedCallbackId = String(argv[1])
            else {
                return FreArgError(message: "setDefaultAudience").getError(#file, #line, #column)
        }
        AccessToken.refreshCurrentAccessToken { _, _, error in
            var props = [String: Any]()
            if let err = error {
                props["callbackId"] = onTokenRefreshFailedCallbackId
                props["data"] = ["message": err.localizedDescription]
                self.dispatchEvent(name: FacebookEvent.ON_TOKEN_REFRESH_FAILED, value: JSON(props).description)
            } else {
                props["callbackId"] = onTokenRefreshedCallbackId
                if let accessToken = AccessToken.current {
                    props["data"] = accessToken.toDictionary()
                }
                self.dispatchEvent(name: FacebookEvent.ON_TOKEN_REFRESH, value: JSON(props).description)
            }
        }
        return nil
    }
    
    func isCurrentAccessTokenActive(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let token = AccessToken.current, token.isExpired == false {
            return true.toFREObject()
        }
        return false.toFREObject()
    }
    
    func isDataAccessActive(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let token = AccessToken.current, token.isDataAccessExpired == false {
            return true.toFREObject()
        }
        return false.toFREObject()
    }
    
    // MARK: - Share
    
    private func createSharingContent(_ freObject: FREObject?) -> SharingContent? {
        guard let className = freObject?.className?.components(separatedBy: "::").last
            else { return nil }
        switch className {
        case "ShareLinkContent":
            return ShareLinkContent(freObject)
        case "SharePhotoContent":
            return SharePhotoContent(freObject)
        case "ShareVideoContent":
            return ShareVideoContent(freObject)
        default:
            break
        }
        return nil
    }
    
    func shareDialog_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let content = createSharingContent(argv[0]),
            let mode = UInt(argv[1])
            else {
                return FreArgError(message: "shareDialog_create").getError(#file, #line, #column)
        }
        let id = UUID().uuidString
        shareDialogs[id] = ShareDialog(fromViewController: UIApplication.shared.keyWindow?.rootViewController,
                                 content: content, delegate: self)
        shareDialogs[id]?.mode = ShareDialog.Mode(rawValue: mode) ?? .automatic
        return id.toFREObject()
    }
    
    func shareDialog_show(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0]),
            let dialog = shareDialogs[id]
            else {
                return FreArgError(message: "shareDialog_show").getError(#file, #line, #column)
        }
        dialog.show()
        return nil
    }
    
    func shareDialog_canShow(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0]),
            let dialog = shareDialogs[id]
            else {
                return FreArgError(message: "shareDialog_canShow").getError(#file, #line, #column)
        }
        return dialog.canShow.toFREObject()
    }
    
    func messageDialog_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let content = createSharingContent(argv[0])
            else {
                return FreArgError(message: "messageDialog_create").getError(#file, #line, #column)
        }
        warning("Starting August 15, 2019, updated versions of the Messenger app will no longer support Share to Messenger SDK.")
        let id = UUID().uuidString
        messageDialogs[id] = MessageDialog(content: content, delegate: self)
        return id.toFREObject()
    }
    
    func messageDialog_show(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError(message: "messageDialog_show").getError(#file, #line, #column)
        }
        messageDialogs[id]?.show()
        return nil
    }
    
    func messageDialog_canShow(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError(message: "messageDialog_canShow").getError(#file, #line, #column)
        }
        return messageDialogs[id]?.canShow.toFREObject()
    }
    
    func shareAPI_create(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let content = createSharingContent(argv[0])
            else {
                return FreArgError(message: "shareAPI_create").getError(#file, #line, #column)
        }
        let id = UUID().uuidString
        shareAPIs[id] = ShareAPI(content: content, delegate: self)
        return id.toFREObject()
    }
    
    func shareAPI_share(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0]),
            let api = shareAPIs[id]
            else {
                return FreArgError(message: "shareAPI_share").getError(#file, #line, #column)
        }
        api.share()
        return nil
    }
    
    func shareAPI_canShare(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0]),
            let api = shareAPIs[id]
            else {
                return FreArgError(message: "shareAPI_canShare").getError(#file, #line, #column)
        }
        return api.canShare.toFREObject()
    }
    
    func onShareSuccess(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        onShareSuccessCallbackId = String(argv[0])
        return nil
    }
    
    func onShareCancel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        onShareCancelCallbackId = String(argv[0])
        return nil
    }
    
    func onShareError(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        onShareErrorCallbackId = String(argv[0])
        return nil
    }
    
}
