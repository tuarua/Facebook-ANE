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
import FBSDKShareKit

public extension SharePhoto {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        self.init()
        let fre = FreObjectSwift(rv)
        if let imageUrl: String = fre.imageUrl, let url = URL(string: imageUrl) {
            imageURL = url
        }
        self.isUserGenerated = fre.isUserGenerated
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> SharePhoto? {
        get { return SharePhoto(rawValue?[name]) }
        set { rawValue?[name] = nil }
    }
    public subscript(dynamicMember name: String) -> [SharePhoto] {
        get { return [SharePhoto](rawValue?[name]) ?? [] }
        set { rawValue?[name] = nil }
    }
}

public extension Array where Element == SharePhoto {
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else { return }
        let array = FREArray(rv)
        for fre in array {
            if let v = SharePhoto(fre) {
                self.append(v)
            }
        }
    }
}
