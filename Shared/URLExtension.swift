//
//  URLExtension.swift
//  Shared
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

extension URL {
    
    init?(withSearch search: String) {
        guard var components = URLComponents(string: "https://duckduckgo.com") else { return nil }
        components.queryItems = [ URLQueryItem(name: "q", value: search) ]
        guard let string = components.string else { return nil }
        self.init(string: string)
    }

    var isEncrypted: Bool {
        return scheme == "https"
    }

    var hostVariations: [String]? {
        guard var parts = host?.components(separatedBy: ".") else { return nil }
        var domains = [String]()
        while parts.count > 1 {
            let domain = parts.joined(separator: ".")
            domains.append(domain)
            parts.removeFirst()
        }
        return domains
    }

}
