//
//  KnownTracker.swift
//  TrackerBlocking
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

public struct KnownTracker: Codable {
    
    public struct Owner: Codable {
        
        public let name: String?
        
        func isEntity(named name: String?) -> Bool {
            guard let name = name else { return false }
            return self.name == name
        }
        
    }
    
    public struct Exception: Codable, Hashable {
        
        public let domains: [String]?
        public let types: [String]?
        
    }
    
    public struct Rule: Codable, Hashable {
        
        public let rule: String
        public let action: String?
        public let exceptions: Exception?

    }
    
    enum CodingKeys: String, CodingKey {
        case domain
        case owner
        case rules
        case prevalence
        case defaultAction = "default"
        case subdomains
    }

    public let domain: String
    public let owner: Owner?
    public let rules: [Rule]?
    public let prevalence: Double
    public let defaultAction: String?
    public let subdomains: [String]?
    
}