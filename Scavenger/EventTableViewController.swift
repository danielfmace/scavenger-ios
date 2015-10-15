//
//  EventTableViewController.swift
//  Scavenger
//
//  Created by Daniel Mace on 10/14/15.
//
//

import UIKit

class EventTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleEvents()
    }
    
    func loadSampleEvents() {
        let photo1 = UIImage(named: "google")
        let event1 = Event(name: "Google Info Session", description: "Information session w/ free bagels", date: "10/25/15", time: "15:30", photo: photo1)!
        
        let photo2 = UIImage(named: "microsoft")
        let event2 = Event(name: "Microsoft Tech Talk", description: "Tech Talk w/ Crozet pizza", date: "10/30/15", time: "19:00", photo: photo2)!
        
        let photo3 = UIImage(named: "capital_one")
        let event3 = Event(name: "Capital One Tech Talk", description: "Tech Talk w/ Mellow pizza", date: "10/28/15", time: "17:00", photo: photo3)!
        
        events += [event1, event2, event3]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        
        cell.nameLabel.text = event.name
        cell.photoImageView.image = event.photo
        cell.descriptionLabel.text = event.description
        cell.dateTimeLabel.text = "\(event.date) - \(event.time)"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EventViewController, event = sourceViewController.event {
            // Add a new event.
            let newIndexPath = NSIndexPath(forRow: events.count, inSection: 0)
            events.append(event)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
    
}
