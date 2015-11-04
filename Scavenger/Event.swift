//
//  Event.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit
import CoreLocation

class Event: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var info: String
    var date: String
    var time: String
    var photo: UIImage?
    var location: CLLocation
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("events")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let infoKey = "info"
        static let dateKey = "date"
        static let timeKey = "time"
        static let photoKey = "photo"
        static let locationKey = "location"
    }
    
    
    init?(name: String, info: String, date: String, time: String, photo: UIImage?, location: CLLocation) {
        // Initialize stored properties.
        self.name = name
        self.info = info
        self.date = date
        self.time = time
        self.photo = photo
        self.location = location
        
        super.init()
        
        // Initialization should fail if there is no name, info, date or time
        if name.isEmpty || info.isEmpty || date.isEmpty || time.isEmpty {
            return nil
        }
        
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(info, forKey: PropertyKey.infoKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(time, forKey: PropertyKey.timeKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let info = aDecoder.decodeObjectForKey(PropertyKey.infoKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! String
        let time = aDecoder.decodeObjectForKey(PropertyKey.timeKey) as! String
        let location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as! CLLocation
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, info: info, date: date, time: time, photo: photo, location: location)
    }
    
}
