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


package com.tuarua.facebookane.extensions

import com.facebook.AccessToken

fun AccessToken?.toMap(): Map<String, Any?> {
    return mapOf("token" to this?.token,
            "userId" to this?.userId,
            "applicationId" to this?.applicationId,
            "source" to this?.source?.ordinal,
            "expires" to this?.expires?.time,
            "lastRefresh" to this?.lastRefresh?.time,
            "dataAccessExpirationTime" to this?.dataAccessExpirationTime?.time,
            "declinedPermissions" to this?.declinedPermissions,
            "expiredPermissions" to this?.expiredPermissions,
            "permissions" to this?.permissions)
}