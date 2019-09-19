//
//  FireOncePixel.swift
//  Statistics
//
//  Copyright © 2019 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Sends a pixel the first time fire is called. Subsequent calls do not resend the pixel
///
public class FireOncePixel {
    
    private let pixel: Pixel
    private let pixelName: PixelName
    private(set) var canFire = true
    
    public init(pixel: Pixel, pixelName: PixelName) {
        self.pixel = pixel
        self.pixelName = pixelName
    }
    
    public func fire() {
        if canFire {
            pixel.fire(pixelName)
            canFire = false
        }
    }
    
}
