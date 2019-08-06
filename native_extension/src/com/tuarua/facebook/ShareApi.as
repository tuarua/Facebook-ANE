package com.tuarua.facebook {
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;
/** A utility class for sharing through the graph API. Using this class requires an access token that
 * has been granted the "publish_actions" permission.*/
public class ShareApi {
    private var _id:String;
    /**
     * @param onSuccess
     * @param onCancel
     * @param onError
     * @param content The content to be shared. */
    public function ShareApi(content:SharingContent, onSuccess:Function, onCancel:Function, onError:Function) {
        var theRet:* = FacebookANEContext.context.call("shareAPI_create", content,
                FacebookANEContext.createEventId(onSuccess),
                FacebookANEContext.createEventId(onCancel),
                FacebookANEContext.createEventId(onError));
        if (theRet is ANEError) throw theRet as ANEError;
        _id = theRet as String;
    }

    /** Begins the send from the receiver. */
    public function share():void {
        var theRet:* = FacebookANEContext.context.call("shareAPI_share", _id);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** A Boolean value that indicates whether the receiver can send the share */
    public function get canShow():Boolean {
        var theRet:* = FacebookANEContext.context.call("shareAPI_canShare", _id);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }
}
}
