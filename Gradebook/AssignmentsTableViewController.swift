//
//  AssignmentsTableViewController.swift
//  Gradebook
//
//  Created by Local Account 123-28 on 2/17/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

class AssignmentsTableViewController: UITableViewController {

    internal var username: String?
    private var assignments: [Assignment]?
    internal var loader: GradebookURLLoader?
    internal var term: String?
    internal var course: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let loader = loader {
            loader.load(path: "?record=userscores&term=\(term!)&course=\(course!)&user=\(username!)") { [weak self] (data, status, error) in
                guard let this = self else { return }
                let json = JSON(data)
                let jsonAssignments = json["userscores"].arrayValue
                this.assignments = [Assignment]()
                for jsonAssignment in jsonAssignments {
                    let myAssignment = Assignment(assignment: jsonAssignment)
                    this.assignments?.append(myAssignment)
                }
                this.tableView.reloadData()
            }
        }
        else {
            print("No loader in AssignmentsTableViewController")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let assignments = assignments {
            return assignments.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath)

        // Configure the cell...
        if let assignments = assignments {
            let assignment = assignments[indexPath.row]
            cell.textLabel?.text = assignment.name
            cell.detailTextLabel?.text = "Score: "
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
