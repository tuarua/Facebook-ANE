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

import FacebookCore
import FacebookShare

public extension ShareVideo {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        self.init()
        let fre = FreObjectSwift(rv)
        if let videoUrl: String = fre.videoUrl, let url = URL(string: videoUrl) {
            videoURL = url
        }
        self.previewPhoto = fre.previewPhoto
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> ShareVideo? {
        get { return ShareVideo(rawValue?[name]) }
        set { rawValue?[name] = nil }
    }
}
