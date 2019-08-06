package com.tuarua.facebook {
public class SharePhotoContent extends SharingContent {
    private var _photos:Vector.<SharePhoto> = new Vector.<SharePhoto>();

    public function SharePhotoContent() {
        super();
    }

    /** Photos to be shared.*/
    public function get photos():Vector.<SharePhoto> {
        return _photos;
    }

    public function set photos(value:Vector.<SharePhoto>):void {
        _photos = value;
    }
}
}
