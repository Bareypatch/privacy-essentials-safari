//
//  URLExtension.swift
//  DuckDuckGo
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
import os

extension URL {
    
    init?(withSearch search: String) {
        guard let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            os_log("encodedSearch is nil")
            return nil
        }
        self.init(string: "https://duckduckgo.com/?q=\(encodedSearch)")
    }
    
}
