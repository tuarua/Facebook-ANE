package com.tuarua.facebookane.extensions

import android.net.Uri
import com.adobe.fre.FREObject
import com.facebook.share.model.ShareHashtag
import com.facebook.share.model.ShareMediaContent
import com.tuarua.frekotlin.FREArray
import com.tuarua.frekotlin.className
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.iterator
import java.util.*

@Suppress("FunctionName")
fun ShareMediaContent(freObject: FREObject?): ShareMediaContent? {
    val rv = freObject ?: return null
    val contentUrl = com.tuarua.frekotlin.String(rv["contentUrl"])
    val hashtag = com.tuarua.frekotlin.String(rv["hashtag"])
    val placeId = com.tuarua.frekotlin.String(rv["placeId"])
    val pageId = com.tuarua.frekotlin.String(rv["pageId"])
    val peopleIds = com.tuarua.frekotlin.List<String>(rv["peopleIds"])

    val builder = ShareMediaContent.Builder()
    if (contentUrl != null) builder.setContentUrl(Uri.parse(contentUrl))
    if (hashtag != null) builder.setShareHashtag(ShareHashtag.Builder().setHashtag(hashtag).build())
    if (placeId != null) builder.setPlaceId(placeId)
    if (pageId != null) builder.setPageId(pageId)
    if (peopleIds.isNotEmpty()) builder.setPeopleIds(peopleIds)

    val freMedia = rv["media"] ?: return builder.build()
    val mediaArr = FREArray(freMedia)
    for (fre: FREObject? in mediaArr) {
        when (fre.className?.splitToSequence("::")?.last() ?: return null) {
            "ShareVideo" -> {
                val video = ShareVideo(fre)
                if (video != null) {
                    builder.addMedium(video)
                }
            }
            "SharePhoto" -> {
                val photo = SharePhoto(fre)
                if (photo != null) {
                    builder.addMedium(photo)
                }
            }
        }
    }
    return builder.build()
}