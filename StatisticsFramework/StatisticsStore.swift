//
//  StatisticsStore.swift
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

public protocol StatisticsStore {
    
    typealias Factory = (() -> StatisticsStore)
    
    var installDate: Date? { get set }
    var installAtb: String? { get set }
    var searchRetentionAtb: String? { get set }
    var appRetentionAtb: String? { get set }
    var browserVersion: String? { get set }
    
}

public class DefaultStatisticsStore: StatisticsStore {
    
    struct Keys {
        
        static let installDate = "installDate"
        static let installAtb = "installAtb"
        static let searchRetentionAtb = "searchRetentionAtb"
        static let appRetentionAtb = "appRetentionAtb"
        static let browserVersion = "browserVersion"

    }

    public var installDate: Date? {
        set {
            userDefaults?.set(newValue?.timeIntervalSince1970, forKey: Keys.installDate)
        }
        get {
            guard let timeInterval = userDefaults?.object(forKey: Keys.installDate) as? Double else { return nil }
            return Date(timeIntervalSince1970: timeInterval)
        }
    }
    
    public var installAtb: String? {
        set {
            userDefaults?.set(newValue, forKey: Keys.installAtb)
        }
        get {
            return userDefaults?.string(forKey: Keys.installAtb)
        }
    }
    
    public var searchRetentionAtb: String? {
        set {
            userDefaults?.set(newValue, forKey: Keys.searchRetentionAtb)
        }
        get {
            return userDefaults?.string(forKey: Keys.searchRetentionAtb)
        }
    }
    
    public var appRetentionAtb: String? {
        set {
            userDefaults?.set(newValue, forKey: Keys.appRetentionAtb)
        }
        get {
            return userDefaults?.string(forKey: Keys.appRetentionAtb)
        }
    }

    public var browserVersion: String? {
        set {
            userDefaults?.set(newValue, forKey: Keys.browserVersion)
        }
        get {
            return userDefaults?.string(forKey: Keys.browserVersion)
        }
    }

    let userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = UserDefaults(suiteName: "group.com.duckduckgo.Statistics")) {
        self.userDefaults = userDefaults
    }
    
}
