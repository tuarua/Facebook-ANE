package com.tuarua.facebook {
public class ShareLinkContent {
    /**
     * The quote to display for this link.
     */
    public var quote:String;
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
    public function ShareLinkContent() {
    }
}
}