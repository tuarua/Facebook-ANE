package com.tuarua.facebook {
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;

/** A utility class for sharing through the graph API. Using this class requires an access token that
 * has been granted the "publish_actions" permission.
 * Android only
 * */
public class ShareApi {
    private var _id:String;

    /**
     * @param content The content to be shared. */
    public function ShareApi(content:SharingContent) {
        var ret:* = FacebookANEContext.context.call("shareAPI_create", content);
        if (ret is ANEError) throw ret as ANEError;
        _id = ret as String;
    }

    /** Begins the send from the receiver. */
    public function share():void {
        var ret:* = FacebookANEContext.context.call("shareAPI_share", _id);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** A Boolean value that indicates whether the receiver can send the share */
    public function get canShow():Boolean {
        var ret:* = FacebookANEContext.context.call("shareAPI_canShare", _id);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }
}
}
