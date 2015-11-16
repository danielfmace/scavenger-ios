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

    @IBOutlet weak var latTextField: UITextField!
    
    @IBOutlet weak var lonTextField: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage?
    var location: CLLocation?
    
    var lat: String?
    var lon: String?
    
    var locationManager: CLLocationManager?
    
    var topInset: CGFloat?
    var leftInset: CGFloat?
    var rightInset: CGFloat?
    var bottomInset: CGFloat?
    
    var oldHeight: CGFloat?
    var oldWidth: CGFloat?
    
    var activeField: UITextField?
    
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Handle name text field's user input through delegate callbacks.
        nameTextField.delegate = self
        infoTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        latTextField.delegate = self
        lonTextField.delegate = self
        
        // Enable the Save button only if the text fields are filled in.
        checkValidFields()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        oldHeight = self.scrollView.contentSize.height
        oldWidth = self.scrollView.contentSize.width
        
        topInset = self.scrollView.contentInset.top
        leftInset = self.scrollView.contentInset.left
        rightInset = self.scrollView.contentInset.right
        bottomInset = self.scrollView.contentInset.bottom
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.scrollView.contentInset = UIEdgeInsetsMake(self.topInset!, self.leftInset!, keyboardHeight, self.rightInset!)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topInset!, self.leftInset!, keyboardHeight, self.rightInset!)
            //self.scrollView.contentSize = CGSizeMake(self.oldWidth!, self.oldHeight! + keyboardHeight + 20)
        })
        
        self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Reset scrollview content inset
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.scrollView.contentInset = UIEdgeInsetsMake(self.topInset!, self.leftInset!, self.bottomInset!, self.rightInset!)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topInset!, self.leftInset!, self.bottomInset!, self.rightInset!)
            //self.scrollView.contentSize = CGSizeMake(self.oldWidth!, self.oldHeight!)
        })
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
            self.scrollView.scrollRectToVisible(self.infoTextField.frame, animated: true)
        }
        else if textField == self.infoTextField {
            self.dateTextField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(self.dateTextField.frame, animated: true)
        }
        else if textField == self.dateTextField {
            self.timeTextField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(self.timeTextField.frame, animated: true)
        }
        else if textField == self.timeTextField {
            self.latTextField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(self.latTextField.frame, animated: true)
        }
        else if textField == self.latTextField {
            self.lonTextField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(self.lonTextField.frame, animated: true)
        }
    
        // Last text field, so hide keyboard
        else {
            // Make a location
            location = CLLocation(latitude: Double(latTextField.text!)!, longitude: Double(lonTextField.text!)!)
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
        
        // Set active field
        activeField = textField
        
    }
    
    func checkValidFields() {
        // Disable the Save button if the text field is empty.
        let nameText = nameTextField.text ?? ""
        let infoText = infoTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        let timeText = timeTextField.text ?? ""
        let latText = latTextField.text ?? ""
        let lonText = lonTextField.text ?? ""
        
        saveButton.enabled = (!nameText.isEmpty && !infoText.isEmpty && !dateText.isEmpty && !timeText.isEmpty && !latText.isEmpty && !lonText.isEmpty)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidFields()
        
        // Reset active field to nil
        activeField = nil
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
            event = Event(name: name, info: info, date: date, time: time, photo: photo, location: location!)
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
    
    
    @IBAction func takePhoto(sender: UIButton) {
        //Hide the keyboard
        view.endEditing(true)
        
        //UIImagePicker is a view controller that lets a user take a photo
        let takeImageController = UIImagePickerController()
        
        //Only allow photos to be taken
        takeImageController.sourceType = .Camera
        
        //Make sure the ViewController is notified when the user picks an image
        takeImageController.delegate = self
        
        presentViewController(takeImageController, animated: true, completion: nil)
        
    }
    
    func takePhotoControllerDidCancel(picker: UIImagePickerController) {
        //dismiss the picker if the user cancelled
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func takeImageController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        image = selectedImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func useCurrentLocation(sender: UIButton) {
        latTextField.text = lat
        lonTextField.text = lon
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        location = newLocation
        lat = String(newLocation.coordinate.latitude)
        lon = String(newLocation.coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    // MARK: Actions
    
}

