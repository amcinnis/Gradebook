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
    
    var enrollments : [Enrollment]?
    var loader : GradebookURLLoader?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
//            if let imageView = cell.viewWithTag(1) as? UIImageView {
//                let picture = enrollment["picture"]
//                loader?.load(path: , compCb: <#T##(Data, Int, Error?) -> Void#>)
//            }
            
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
        if let enrollment = enrollments[indexPath.row] {
            
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
