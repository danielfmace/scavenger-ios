//
//  UIViewControllerExtension.swift
//  Scavenger
//
//  Created by Daniel Mace on 11/23/15.
//
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorView(error: NSError) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}