//
//  EventViewController.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit

class EventViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle name text field's user input through delegate callbacks.
        nameTextField.delegate = self
        descriptionTextField.delegate = self
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
            self.descriptionTextField.becomeFirstResponder()
        }
        else if textField == self.descriptionTextField {
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
        let descriptionText = descriptionTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        let timeText = timeTextField.text ?? ""
        
        saveButton.enabled = (!nameText.isEmpty && !descriptionText.isEmpty && !dateText.isEmpty && !timeText.isEmpty)
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
            //let photo =
            let description = descriptionTextField.text ?? ""
            let date = dateTextField.text ?? ""
            let time = timeTextField.text ?? ""
            
            // Set the event to be passed to EventTableViewController after the unwind segue.
            event = Event(name: name, description: description, date: date, time: time, photo: nil)
        }
    }
    
    // MARK: Actions
    
}

