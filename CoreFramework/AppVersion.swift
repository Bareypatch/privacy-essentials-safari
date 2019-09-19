//
//  AppVersion.swift
//  Core
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

public protocol AppVersion {
    var name: String { get }
    var identifier: String { get }
    var versionNumber: String { get }
    var buildNumber: String { get }
}

extension AppVersion {
    public var fullVersion: String {
        return "\(versionNumber).\(buildNumber)"
    }
}

public struct DefaultAppVersion: AppVersion {
    
    struct Keys {
        static let name = kCFBundleNameKey as String
        static let identifier = kCFBundleIdentifierKey as String
        static let buildNumber = kCFBundleVersionKey as String
        static let versionNumber = "CFBundleShortVersionString"
    }
    
    private let bundle: InfoBundle
    
    public init(bundle: InfoBundle = Bundle.main) {
        self.bundle = bundle
    }
    
    public var name: String {
        return bundle.object(forInfoDictionaryKey: Keys.name) as? String ?? ""
    }
    
    public var identifier: String {
        return bundle.object(forInfoDictionaryKey: Keys.identifier) as? String ?? ""
    }
    
    public var versionNumber: String {
        return bundle.object(forInfoDictionaryKey: Keys.versionNumber) as? String ?? ""
    }
    
    public var buildNumber: String {
        return bundle.object(forInfoDictionaryKey: Keys.buildNumber) as? String ?? ""
    }
}

public protocol InfoBundle {
    func object(forInfoDictionaryKey key: String) -> Any?
}

extension Bundle: InfoBundle {
}
