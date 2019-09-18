//
//  SafariExtensionViewController.swift
//  Safari
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

import TrackerBlocking
import SafariServices
import Statistics

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width: 300, height: 558)
        return shared
    }()

    @IBOutlet weak var tabs: NSTabView!
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchButton: NSButton!
    @IBOutlet weak var menuButton: NSButton!

    weak var navigationController: NavigationController!

    var pageData: PageData? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        NSLog("SEVC viewDidLoad")
        super.viewDidLoad()
        
        initSearchPlaceholder()
        initButton(searchButton)
        initButton(menuButton)
        
        installPageController()
    }

    override func viewWillAppear() {
        NSLog("SEVC viewWillAppear")
        super.viewWillAppear()
        tabs.selectedTabViewItem?.viewController?.viewWillAppear()
        StatisticsLoader().refreshAppRetentionAtb(atLocation: "sevc", completion: nil)
    }
    
    override func viewDidAppear() {
        NSLog("SEVC viewDidAppear")
        super.viewDidAppear()
        updateSearchFieldCaretColor()
    }

    @IBAction func performSearch(sender: Any) {
        guard !searchField.stringValue.isEmpty else { return }

        guard let url = URL(withSearch: searchField.stringValue) else { return }
        
        NSWorkspace.shared.open(url)
        dismissPopover()
    }
    
    private func updateSearchFieldCaretColor() {
        guard let window = searchField.window,
            let fieldEditor = window.fieldEditor(true, for: searchField) as? NSTextView else { return }
        fieldEditor.insertionPointColor = .white
    }
    
    private func initButton(_ button: NSButton) {
        let cell = button.cell as? NSButtonCell
        cell?.backgroundColor = NSColor.clear
    }
    
    private func initSearchPlaceholder() {
        let color = NSColor.searchPlaceholderText
        let cell = searchField.cell as? NSTextFieldCell
        let font = NSFont(name: "Proxima Nova Regular", size: 16) ?? NSFont.systemFont(ofSize: 16)
        let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        let placeHolderStr = NSAttributedString(string: "Search DuckDuckGo", attributes: attrs as [NSAttributedString.Key: Any])
        cell?.placeholderAttributedString = placeHolderStr
        cell?.drawsBackground = true
        cell?.backgroundColor = NSColor.clear
    }
    
    private func installPageController() {
        guard let navigationController = NSViewController.loadController(named: "NavController",
                                                                         fromStoryboardNamed: "Dashboard") as? NavigationController else {
            fatalError("failed to load \(NavigationController.self)")
        }
        tabs.addTabViewItem(NSTabViewItem(viewController: navigationController))
        navigationController.pageData = pageData
        self.navigationController = navigationController
    }

    private func updateUI() {
        NSLog("SEVC \(#function) \(navigationController as Any)")
        navigationController?.pageData = pageData
    }
    
}