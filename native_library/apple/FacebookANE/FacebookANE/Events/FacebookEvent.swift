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

public struct FacebookEvent {
    static let ON_LOGIN_SUCCESS = "FacebookEvent.OnLoginSuccess"
    static let ON_LOGIN_CANCEL = "FacebookEvent.OnLoginCancel"
    static let ON_LOGIN_ERROR = "FacebookEvent.OnLoginError"
    static let ON_SHARE_SUCCESS = "FacebookEvent.OnShareSuccess"
    static let ON_SHARE_CANCEL = "FacebookEvent.OnShareCancel"
    static let ON_SHARE_ERROR = "FacebookEvent.OnShareError"
    static let ON_TOKEN_REFRESH = "FacebookEvent.OnTokenRefresh"
    static let ON_TOKEN_REFRESH_FAILED = "FacebookEvent.OnTokenRefreshFailed"
    static let ON_CURRENT_ACCESS_TOKEN_CHANGED = "FacebookEvent.onCurrentAccessTokenChanged"
}
