//
//  ScoresTableViewController.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/17/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {

    var assignment: Assignment?
    private var gradedSubmissions = [Score]()
    private var otherSubmissions: [Score]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let assignment = assignment {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            for score in assignment.scores {
                if score.counts {
                    gradedSubmissions.append(score)
                }
                else {
                    if otherSubmissions == nil {
                        otherSubmissions = [Score]()
                    }
                    otherSubmissions?.append(score)
                }
            }
            if let otherSubmissions = otherSubmissions {
                self.otherSubmissions = otherSubmissions.sorted { (score1, score2) in
                    return score1.postDate.compare(score2.postDate as Date) == .orderedDescending
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let assignment = assignment {
            if assignment.scores.count > 1 {
                return 2
            }
            else {
                return 1
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let assignment = assignment {
            if assignment.scores.count > 1 {
                if section == 0 {
                    return gradedSubmissions.count
                }
                else {
                    return (otherSubmissions?.count)!
                }
            }
            else {
                return assignment.scores.count
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)

        // Configure the cell...
        if (assignment != nil) {
            var score: Score
            if indexPath.section == 0 {
                score = gradedSubmissions[indexPath.row]
                cell.accessoryType = .checkmark
            }
            else {
                score = (otherSubmissions?[indexPath.row])!
            }
            cell.textLabel?.text = "Score: \(score.displayScore)"
            cell.detailTextLabel?.text = "\(score.postDate.description)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Graded Submission"
        case 1:
            return "Other Submissions"
        default:
            return ""
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
