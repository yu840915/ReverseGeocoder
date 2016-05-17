//
//  ViewController.swift
//  ReverseGeocoder
//
//  Created by small on 5/15/16.
//  Copyright © 2016 small. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchField: NSSearchField!
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController: NSTextFieldDelegate {
    override func controlTextDidChange(obj: NSNotification) {
        debugPrint(searchField.stringValue)
        let address = searchField.stringValue
        if !address.isEmpty {
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                debugPrint(placemarks)
                debugPrint(error)
            })
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 0
    }
    
    
}