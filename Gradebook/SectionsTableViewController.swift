//
//  SectionsTableViewController.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/15/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

class SectionsTableViewController: UITableViewController {

    var sections: [Section]?
    var enrollments: [Enrollment]?
    var loader: GradebookURLLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if let count = sections?.count {
            return count
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)

        // Configure the cell...
        if let section = sections?[indexPath.row] {
            let deptName = section.dept
            let courseName = section.course
            
            cell.textLabel?.text = "\(deptName) \(courseName)"
            cell.detailTextLabel?.text = section.title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections?[indexPath.row]
        if let section = section {
            let term = section.term
            let course = section.course
            loader?.load(path:"?record=enrollments&term=\(term)&course=\(course)") {
                [weak self] (data, status, error) in
                guard let this = self else { return }
                let json = JSON(data)
                if let enrollments = json["enrollments"].array {
                    this.enrollments = [Enrollment]()
                    for enrollment in enrollments {
                        let myEnrollment = Enrollment(enrollment: enrollment, loader: this.loader)
                        this.enrollments?.append(myEnrollment)
                    }
                    this.performSegue(withIdentifier: "ShowEnrollments", sender: nil)
                }
                else {
                    print("Enrollments loading error.")
                }
            }
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowEnrollments" {
            if let destVC = segue.destination as? EnrollmentsViewController {
                if let enrollments = self.enrollments {
                    destVC.enrollments = enrollments
                }
            }
        }
    }
    

}
