package com.tuarua.facebook {
public class ShareVideo implements ShareMedia {
    private var _videoUrl:String;
    private var _previewPhoto:SharePhoto;

    /** A video for sharing. */
    public function ShareVideo() {
    }

    /** The file URL to the video. */
    public function get videoUrl():String {
        return _videoUrl;
    }

    public function set videoUrl(value:String):void {
        _videoUrl = value;
    }

    /** The photo that represents the video.*/
    public function get previewPhoto():SharePhoto {
        return _previewPhoto;
    }

    public function set previewPhoto(value:SharePhoto):void {
        _previewPhoto = value;
    }


}
}
