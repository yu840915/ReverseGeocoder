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
    var currentQuery: String?
    let geocoder = CLGeocoder()
    var placemarks: [PlacemarkDatasource]? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        let address = searchField.stringValue
        currentQuery = address
        if !address.isEmpty {
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                guard self.currentQuery == address else {
                    return
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.placemarks = placemarks?.map{PlacemarkDatasource(placemark: $0)}
                })
            })
        } else {
            placemarks = nil
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return placemarks?.count ?? 0
    }
    
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return placemarks![row].valueForAttributeID(PlacemarkDatasource.AttributeID(rawValue: tableColumn!.identifier)!)
    }
}

struct PlacemarkDatasource {
    enum AttributeID: String {
        case Name
        case Country
        case AdminArea
        case SubAdminArea
        case Locality
        case SubLocality
    }
    
    let placemark: CLPlacemark
    
    func valueForAttributeID(attrID: AttributeID) -> AnyObject {
        func interpretValue(value: String?) -> String {
            if let value = value {
                return value.isEmpty ? "[空字串]" : value
            }
            return "[空值!]"
        }
        
        switch attrID {
        case .Name:
            return interpretValue(placemark.name)
        case .Country:
            return "\(interpretValue(placemark.country))/\(interpretValue(placemark.ISOcountryCode))"
        case .AdminArea:
            return interpretValue(placemark.administrativeArea)
        case .SubAdminArea:
            return interpretValue(placemark.subAdministrativeArea)
        case .Locality:
            return interpretValue(placemark.locality)
        case .SubLocality:
            return interpretValue(placemark.subLocality)
        }
    }
}