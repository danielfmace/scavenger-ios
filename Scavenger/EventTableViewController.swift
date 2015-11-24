//
//  EventTableViewController.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit
import CoreLocation
import Parse
import ParseUI

class EventTableViewController: PFQueryTableViewController {
    
    // MARK: Properties
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = Event.query()
        return query!
    }
    
    func loadSampleEvents() {
        let location = CLLocation(latitude: 38.0316114, longitude: -78.5107279)
        let geoPoint = PFGeoPoint(location: location)
        let photo1 = UIImage(named: "google")
        let photo2 = UIImage(named: "capital_one")
        let photo3 = UIImage(named: "microsoft")
        
        let pictureData1 = UIImagePNGRepresentation(photo1!)
        let pictureData2 = UIImagePNGRepresentation(photo2!)
        let pictureData3 = UIImagePNGRepresentation(photo3!)
        
        let file1 = PFFile(name: "image1", data: pictureData1!)
        let file2 = PFFile(name: "image2", data: pictureData2!)
        let file3 = PFFile(name: "image3", data: pictureData3!)
        
        
        let event1 = Event(name: "Google Info Session", info: "Information session w/ free bagels", date: "10/25/15", time: "15:30", photo: file1, location: geoPoint)!
        
        //let photo2 = UIImage(named: "microsoft")
        let event2 = Event(name: "Microsoft Tech Talk", info: "Tech Talk w/ Crozet pizza", date: "10/30/15", time: "19:00", photo: file3, location: geoPoint)!
        
        //let photo3 = UIImage(named: "capital_one")
        let event3 = Event(name: "Capital One Tech Talk", info: "Tech Talk w/ Mellow pizza", date: "10/28/15", time: "17:00", photo: file2, location: geoPoint)!
        
        events += [event1, event2, event3]
        
        for event in events {
            event.saveInBackgroundWithBlock{ succeeded, error in
                if succeeded {

                    self.navigationController?.popViewControllerAnimated(true)
                } else {

                    if let errorMessage = error?.userInfo["error"] as? String {
                        self.showErrorView(error!)
                    }
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let event = object as! Event
        
        events += [event]
        
        if let image = event.photo {
            cell.photoImageView!.file = image
            
            cell.photoImageView!.loadInBackground()
        }
        else {
            cell.photoImageView!.image = UIImage(named: "defaultPhoto")
        }

        cell.nameLabel.text = event.name

        cell.infoLabel.text = event.info
        cell.dateTimeLabel.text = "\(event.date) - \(event.time)"

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let toDelete = events[indexPath.row]
            toDelete.deleteInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    self.loadObjects()
                    self.tableView.reloadData()
                } else if let error = error {
                    self.showErrorView(error)
                }
                })
            events.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //saveEvents()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            // Get the cell that generated this segue.
            if let selectedEventCell = sender as? EventTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedEventCell)!
                let selectedEvent = events[indexPath.row]
                detailViewController.event = selectedEvent
            }
        }
    }

    
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EventViewController, event = sourceViewController.event {
            // Add a new event.
            self.loadObjects()
            print("Objects loaded")
            //let newIndexPath = NSIndexPath(forRow: events.count, inSection: 0)
            //events.append(event)
            //tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
        // Save the events.
        //saveEvents()
    }
    
    // MARK: NSCoding
    
    //func saveEvents() {
    //    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(events, toFile: Event.ArchiveURL.path!)
    //    if !isSuccessfulSave {
    //        print("Failed to save events...")
    //    }
    //}
    
//    func getEvents() {
//        let query = Event.query()!
//        query.findObjectsInBackgroundWithBlock { objects, error in
//            if error == nil {
//                if let objects = objects as? [Event] {
//                    self.loadEventViews(objects)
//                }
//            } else if let error = error {
//                self.showErrorView(error)
//            }
//        }
//    }
    
}
