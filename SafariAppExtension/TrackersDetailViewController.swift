//
//  TrackersDetailViewController.swift
//  SafariAppExtension
//
//  Created by Chris Brind on 03/07/2019.
//  Copyright © 2019 Duck Duck Go, Inc. All rights reserved.
//

import AppKit
import TrackerBlocking

class TrackersDetailViewController: DashboardNavigationController {
    
    enum TableDataItem {
        
        case pageHeader
        case entity(name: String, imageName: String)
        case tracker(domain: String, category: String?)
        case entitySeparator
        
    }
    
    @IBOutlet weak var outline: NSOutlineView!
    
    override var pageData: PageData? {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    var dataItems = [TableDataItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outline.delegate = self
        outline.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        updateUI()
    }
    
    private func updateUI() {
        dataItems = [ .pageHeader ] + (pageData?.trackerBreakdown() ?? [])
        NSLog("dataItems \(dataItems)")
        outline.reloadData()
    }

}

extension TrackersDetailViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return dataItems.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return dataItems[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {

        guard let dataItem = item as? TableDataItem else {
            fatalError("Unexpected item \(item) in table data")
        }
        
        switch dataItem {
        case .pageHeader:
            return 286
        
        case .entity:
            return 50
        
        case .tracker:
            return 20
            
        case .entitySeparator:
            return 15
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return nil
    }
    
}

extension TrackersDetailViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {

        guard let dataItem = item as? TableDataItem else {
            fatalError("Unexpected item \(item) in table data")
        }

        switch dataItem {
        case .pageHeader:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("HeaderCell"), owner: self)
                as? TrackersDetailHeaderView
            view?.domainLabel.stringValue = pageData?.url?.host?.dropPrefix("www.") ?? ""
            view?.trackersLabel.stringValue = pageData?.trackersText.uppercased() ?? ""
            view?.imageView?.image = pageData?.networksHeroIcon
            return view
            
        case .entity(let name, let imageName):
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("EntityCell"), owner: self)
                as? TrackersDetailEntityView
            view?.entityNameLabel.stringValue = name
            view?.imageView?.image = NSImage(named: NSImage.Name(imageName))
            return view
            
        case .tracker(let domain, let category):
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("TrackerCell"), owner: self)
                as? TrackersDetailTrackerView
            view?.trackerLabel.stringValue = domain
            view?.typeLabel.stringValue = category ?? ""
            return view
            
        case .entitySeparator:
            return NSView()
            
        }
        
    }
        
}

class TrackersDetailHeaderView: NSTableCellView {
    
    @IBOutlet weak var domainLabel: NSTextField!
    @IBOutlet weak var trackersLabel: NSTextField!
    
}

class TrackersDetailEntityView: NSTableCellView {

    @IBOutlet weak var entityNameLabel: NSTextField!

}

class TrackersDetailTrackerView: NSTableCellView {
    
    @IBOutlet weak var trackerLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!

}

extension PageData {
    
    func trackerBreakdown() -> [ TrackersDetailViewController.TableDataItem ] {
        let trackersByEntity = isTrusted ? loadedTrackersByEntity() : blockedTrackersByEntity()

        return trackersByEntity.map { t -> [ TrackersDetailViewController.TableDataItem ] in
            let entity = TrackersDetailViewController.TableDataItem.entity(name: t.entityName, imageName: "PP Network Icon \(t.entityName)")
            let trackers = t.trackers.map { TrackersDetailViewController.TableDataItem.tracker(domain: $0, category: nil) }
            return [ entity ] + trackers + [ .entitySeparator ]
        }.flatMap { $0 }

    }

    var trackersText: String {
        if isTrusted {
            let count = loadedTrackers.uniqueDomains
            return String(format: UserText.trackersFound, count)
        } else {
            let count = blockedTrackers.uniqueDomains
            return String(format: UserText.trackersBlocked, count)
        }

    }

    var networksHeroIcon: NSImage? {
        let imageName: String
        if isTrusted {
            imageName = loadedTrackers.count == 0 ? "PP Hero Major Off" : "PP Hero Major Bad"
        } else {
            imageName = "PP Hero Major On"
        }
        return NSImage(named: NSImage.Name(imageName))
    }
    
}

fileprivate extension Array where Element == DetectedTracker {
    
    var uniqueDomains: Int {
        var domains = Set<String>()
        forEach({ domains.insert($0.resource.host ?? "") })
        return domains.count
    }
    
}
