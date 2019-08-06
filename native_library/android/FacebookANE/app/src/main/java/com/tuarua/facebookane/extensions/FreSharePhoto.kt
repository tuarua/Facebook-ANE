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

import android.net.Uri
import com.adobe.fre.FREObject
import com.facebook.share.model.SharePhoto
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun SharePhoto(freObject: FREObject?): SharePhoto? {
    val rv = freObject ?: return null
    val imageUrl = String(rv["imageUrl"])
    val isUserGenerated = Boolean(rv["isUserGenerated"]) == true
    val builder = SharePhoto.Builder()
    if (imageUrl != null) builder.setImageUrl(Uri.parse(imageUrl))
    builder.setUserGenerated(isUserGenerated)
    return builder.build()
}