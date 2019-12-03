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

public extension AccessToken {
    func toDictionary() -> [String: Any?] {
        return ["applicationId": appID,
                "token": tokenString,
                "userId": userID,
                "expires": expirationDate.timeIntervalSince1970 * 1000.0,
                "lastRefresh": refreshDate.timeIntervalSince1970 * 1000.0,
                "dataAccessExpirationTime": dataAccessExpirationDate.timeIntervalSince1970 * 1000.0,
                "declinedPermissions": declinedPermissions.compactMap { $0.name },
                "permissions": permissions.compactMap { $0.name },
                "expiredPermissions": expiredPermissions.compactMap { $0.name },
                "source": 4]
    }
}
