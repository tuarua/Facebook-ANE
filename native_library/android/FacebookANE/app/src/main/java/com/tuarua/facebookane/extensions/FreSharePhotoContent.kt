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
import com.facebook.share.model.ShareHashtag
import com.facebook.share.model.SharePhotoContent
import com.tuarua.frekotlin.*

@Suppress("FunctionName")
fun SharePhotoContent(freObject: FREObject?): SharePhotoContent? {
    val rv = freObject ?: return null
    val contentUrl = String(rv["contentUrl"])
    val hashtag = String(rv["hashtag"])
    val placeId = String(rv["placeId"])
    val pageId = String(rv["pageId"])
    val peopleIds = List<String>(rv["peopleIds"])
    val frePhotos = rv["photos"]

    val builder = SharePhotoContent.Builder()
    if (contentUrl != null) builder.setContentUrl(Uri.parse(contentUrl))
    if (hashtag != null) builder.setShareHashtag(ShareHashtag.Builder().setHashtag(hashtag).build())
    if (placeId != null) builder.setPlaceId(placeId)
    if (pageId != null) builder.setPageId(pageId)
    if (peopleIds.isNotEmpty()) builder.setPeopleIds(peopleIds)
    if (frePhotos != null) {
        val freArray = FREArray(frePhotos)
        for (fre: FREObject? in freArray) {
            val photo = SharePhoto(fre)
            if (photo != null) {
                builder.addPhoto(photo)
            }
        }
    }
    return builder.build()
}