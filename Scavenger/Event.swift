//
//  Event.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit

class Event {
    // MARK: Properties
    
    var name: String
    var description: String
    var date: String
    var time: String
    var photo: UIImage?
    
    init?(name: String, description: String, date: String, time: String, photo: UIImage?) {
        // Initialize stored properties.
        self.name = name
        self.description = description
        self.date = date
        self.time = time
        self.photo = photo
        // Initialization should fail if there is no name, description, date or time
        if name.isEmpty || description.isEmpty || date.isEmpty || time.isEmpty {
            return nil
        }
        
    }
    
}
