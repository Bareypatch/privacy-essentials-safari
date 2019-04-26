//
//  DomainPromptViewController.swift
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

import Cocoa

class DomainPromptViewController: NSViewController {
    
    weak var delegate: DomainPromptDelegate?
    
    @IBOutlet weak var textField: NSTextField!
    
    @IBAction func save(sender: Any) {
        delegate?.addDomain(textField.stringValue)
        dismiss(self)
    }
}

protocol DomainPromptDelegate: NSObjectProtocol {
    
    func addDomain(_ domain: String)
    
}
