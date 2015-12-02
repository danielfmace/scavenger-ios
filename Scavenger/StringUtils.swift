//
//  StringUtils.swift
//  Scavenger
//
//  Created by Katie Banach on 12/1/15.
//
//

import Foundation


extension String {
    
    func containsOnly(matchCharacters: String) -> Bool {
        
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
}