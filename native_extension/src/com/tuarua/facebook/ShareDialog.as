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

/** A dialog for sharing content on Facebook. */
public class ShareDialog {
    private var _id:String;
    private var _content:SharingContent;
    /**
     * @param mode The mode with which to display the dialog.
     * @param content The content to be shared. */
    public function ShareDialog(content:SharingContent, mode:uint = ShareDialogMode.automatic) {
        _content = content;
        var ret:* = FacebookANEContext.context.call("shareDialog_create", _content, mode);
        if (ret is ANEError) throw ret as ANEError;
        _id = ret as String;
    }

    /** Shows the dialog. */
    public function show():void {
        var ret:* = FacebookANEContext.context.call("shareDialog_show", _id, _content);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** A Boolean value that indicates whether the receiver can initiate a share.
     *
     * May return false if the appropriate Facebook app is not installed and is required or an access token is
     * required but not available. This method does not validate the content on the receiver, so this can be
     * checked before building up the content.
     * */
    public function get canShow():Boolean {
        var ret:* = FacebookANEContext.context.call("shareDialog_canShow", _id);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }
}
}
