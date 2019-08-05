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
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;
/** A dialog for sharing content through Messenger. */
public class MessageDialog {
    private var _id:String;
    private var _content:SharingContent;
    /**
     * @param onSuccess
     * @param onCancel
     * @param onError
     * @param content The content to be shared. */
    public function MessageDialog(content:SharingContent, onSuccess:Function, onCancel:Function, onError:Function) {
        _content = content;
        var theRet:* = FacebookANEContext.context.call("messageDialog_create", content,
                FacebookANEContext.createEventId(onSuccess),
                FacebookANEContext.createEventId(onCancel),
                FacebookANEContext.createEventId(onError));
        if (theRet is ANEError) throw theRet as ANEError;
        _id = theRet as String;
    }

    /** Shows the dialog. */
    public function show():void {
        var theRet:* = FacebookANEContext.context.call("messageDialog_show", _id, _content);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** A Boolean value that indicates whether the receiver can initiate a share.
     *
     * May return false if the appropriate Facebook app is not installed and is required or an access token is
     * required but not available. This method does not validate the content on the receiver, so this can be
     * checked before building up the content.
     * */
    public function get canShow():Boolean {
        var theRet:* = FacebookANEContext.context.call("messageDialog_canShow", _id);
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }
}
}
