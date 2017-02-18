//
//  EnrollmentsViewController.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/15/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EnrollmentCell"

class EnrollmentsViewController: UICollectionViewController {
    
    private var enrollments: [Enrollment]?
    internal var enrollment: Enrollment?
    var loader : GradebookURLLoader?
    internal var term: String?
    internal var course: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        if let loader = loader {
            loader.load(path:"?record=enrollments&term=\(term!)&course=\(course!)") {
                [weak self] (data, status, error) in
                guard let this = self else { return }
                let json = JSON(data)
                print("Inside loader")
                if let enrollments = json["enrollments"].array {
                    this.enrollments = [Enrollment]()
                    for enrollment in enrollments {
                        let myEnrollment = Enrollment(enrollment: enrollment, loader: this.loader)
                        this.enrollments?.append(myEnrollment)
                    }
                }
                else {
                    print("Enrollments loading error.")
                }
                this.collectionView?.reloadData()
            }
        }
        else {
            print("No loader in EnrollmentsViewController")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowAssignments" {
            if let destVC = segue.destination as? AssignmentsTableViewController {
                if let enrollment = self.enrollment {
                    destVC.username = enrollment.username
                    destVC.term = term
                    destVC.course = course
                    destVC.loader = loader
                }
            }
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let count = enrollments?.count {
            return count
        }
        else {
            print("No enrollments count")
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let enrollment = enrollments?[indexPath.row] {
            
            let nameLabel = UILabel(frame: CGRect(x: 0.0, y: cell.frame.height, width: cell.frame.size.width, height: cell.frame.size.height / 5.0))
            let firstName = enrollment.firstName
            let lastName = enrollment.lastName
            nameLabel.text = "\(firstName) \(lastName)"
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.textAlignment = .center
            cell.contentView.addSubview(nameLabel)
            
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: cell.frame.size.width, height: cell.frame.size.height))
            imageView.image = enrollment.picture
            cell.addSubview(imageView)
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let enrollments = enrollments {
            enrollment = enrollments[indexPath.row]
            performSegue(withIdentifier: "ShowAssignments", sender: nil)
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
