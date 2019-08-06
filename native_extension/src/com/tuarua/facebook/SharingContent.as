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
package com.tuarua.facebook {
public class SharingContent {
    /**
     * The URL for the content being shared.
     */
    public var contentUrl:String;
    /**
     * The Hashtag for this content
     */
    public var hashtag:String;
    /**
     * The Id for the place to tag.
     */
    public var placeId:String;
    /**
     * The Id of the Facebook page this share is associated with.
     */
    public var pageId:String;
    /**
     * The list of Ids for taggable people to tag with this content.
     */
    public var peopleIds:Vector.<String> = new Vector.<String>();
    public function SharingContent() {
    }
}
}
