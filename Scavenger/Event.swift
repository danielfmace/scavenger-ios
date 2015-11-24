//
//  Event.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit
import CoreLocation
import Foundation

class Event: PFObject, PFSubclassing {
    // MARK: Properties
    
    @NSManaged var name: String
    @NSManaged var info: String
    @NSManaged var date: String
    @NSManaged var time: String
    @NSManaged var photo: PFFile?
    @NSManaged var location: PFGeoPoint
    
    
    init?(name: String, info: String, date: String, time: String, photo: PFFile?, location: PFGeoPoint) {
        super.init()
        
        // Initialize stored properties.
        self.name = name
        self.info = info
        self.date = date
        self.time = time
        self.photo = photo
        self.location = location
        
        // Initialization should fail if there is no name, info, date or time
        if name.isEmpty || info.isEmpty || date.isEmpty || time.isEmpty {
            return nil
        }
        
    }
    
    override init() {
        super.init()
    }
    
    class func parseClassName() -> String {
        return "Event"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Event.parseClassName())

        query.orderByDescending("createdAt")
        return query
    }
    
}
