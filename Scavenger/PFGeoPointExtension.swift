//
//  PFGeoPointExtension.swift
//  Scavenger
//
//  Created by Daniel Mace on 11/23/15.
//
//

import Foundation
import Parse

extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}