//
//  EventViewController.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit
import CoreLocation

class EventViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var image: UIImage?
    
    let locationManager = CLLocationManager()
    
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager and start getting location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Handle name text field's user input through delegate callbacks.
        nameTextField.delegate = self
        infoTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        
        // Enable the Save button only if the text fields are filled in.
        checkValidFields()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Move to next text field
        if textField == self.nameTextField {
            let nameText = nameTextField.text ?? ""
            if !nameText.isEmpty {
                navigationItem.title = nameText
            }
            self.infoTextField.becomeFirstResponder()
        }
        else if textField == self.infoTextField {
            self.dateTextField.becomeFirstResponder()
        }
        else if textField == self.dateTextField {
            self.timeTextField.becomeFirstResponder()
        }
            
        // Last text field, so hide keyboard
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidFields() {
        // Disable the Save button if the text field is empty.
        let nameText = nameTextField.text ?? ""
        let infoText = infoTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        let timeText = timeTextField.text ?? ""
        
        saveButton.enabled = (!nameText.isEmpty && !infoText.isEmpty && !dateText.isEmpty && !timeText.isEmpty)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidFields()
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = image
            let info = infoTextField.text ?? ""
            let date = dateTextField.text ?? ""
            let time = timeTextField.text ?? ""
            
            // Set the event to be passed to EventTableViewController after the unwind segue.
            event = Event(name: name, info: info, date: date, time: time, photo: photo)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UIButton) {
        // Hide the keyboard
        view.endEditing(true)
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set image as selectedImage from Image Picker
        image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
 /*
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Error: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Error with the data.")
            }
        })
    }
*/
    func displayLocationInfo(placemark: CLPlacemark)
    {
        
        self.locationManager.stopUpdatingLocation()
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        print("Error: " + error.localizedDescription)
    }
    
    // MARK: Actions
    
}

