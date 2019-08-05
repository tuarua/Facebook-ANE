package com.tuarua.facebook {
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;

public class ShareApi {
    private var _id:String;
    public function ShareApi(content:SharingContent, onSuccess:Function, onCancel:Function, onError:Function) {
        var theRet:* = FacebookANEContext.context.call("shareAPI_create", content,
                FacebookANEContext.createEventId(onSuccess),
                FacebookANEContext.createEventId(onCancel),
                FacebookANEContext.createEventId(onError));
        if (theRet is ANEError) throw theRet as ANEError;
        _id = theRet as String;
    }
    public function share():void {
        var theRet:* = FacebookANEContext.context.call("shareAPI_share", _id);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get canShow():Boolean {
        var theRet:* = FacebookANEContext.context.call("shareAPI_canShare", _id);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }
}
}
