/* Copyright 2019 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import FreSwift
import FacebookShare
import SwiftyJSON

public extension SwiftController {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String: Any]) {
        guard let onSuccessCallbackId = self.onShareSuccessCallbackId else { return }
        var props = [String: Any]()
        props["callbackId"] = onSuccessCallbackId
        props["data"] = ["postId": ""]
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_SUCCESS, value: JSON(props).description)
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        guard let onErrorCallbackId  = self.onShareErrorCallbackId  else { return }
        var props = [String: Any]()
        props["callbackId"] = onErrorCallbackId
        props["data"] = ["message": error.localizedDescription]
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_ERROR, value: JSON(props).description)  
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        guard let onCancelCallbackId = self.onShareCancelCallbackId else { return }
        var props = [String: Any]()
        props["callbackId"] = onCancelCallbackId
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_CANCEL, value: JSON(props).description)
    }
}
