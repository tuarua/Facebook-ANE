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
import FBSDKShareKit

public extension SwiftController {
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String: Any]) {
        trace("didCompleteWithResults")
        guard let onSuccessEventId = self.onShareSuccessEventId else { return }
        trace("results", results.debugDescription)
        var props = [String: Any]()
        props["eventId"] = onSuccessEventId
        props["data"] = ["postId": ""]
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_SUCCESS, value: JSON(props).description)
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        trace("didFailWithError")
        guard let onErrorEventId  = self.onShareErrorEventId  else { return }
        var props = [String: Any]()
        props["eventId"] = onErrorEventId
        props["data"] = ["message": error.localizedDescription]
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_ERROR, value: JSON(props).description)  
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        trace("onCancelEventId")
        guard let onCancelEventId = self.onShareCancelEventId else { return }
        var props = [String: Any]()
        props["eventId"] = onCancelEventId
        self.dispatchEvent(name: FacebookEvent.ON_SHARE_CANCEL, value: JSON(props).description)
    }
}
