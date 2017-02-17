//
//  Enrollment.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/16/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation
import UIKit

class Enrollment {
    var id: String
    var major: String
    var emplid: String
    var age: String
    var ferpa: String
    var cscUsername: String
    var middleName: String
    var adminFailure: String
    var picture: UIImage?
    var bbID: String
    var dropped: String
    var firstName: String
    var lastName: String
    var emailLevel: String
    var role: String
    var username: String
    
    init(enrollment: JSON, loader: GradebookURLLoader?) {
        self.id = enrollment["id"].stringValue
        self.major = enrollment["major"].stringValue
        self.emplid = enrollment["emplid"].stringValue
        self.age = enrollment["age"].stringValue
        self.ferpa = enrollment["ferpa"].stringValue
        self.cscUsername = enrollment["csc_username"].stringValue
        self.middleName = enrollment["middle_name"].stringValue
        self.adminFailure = enrollment["admin_failure"].stringValue
        self.bbID = enrollment["bb_id"].stringValue
        self.dropped = enrollment["dropped"].stringValue
        self.firstName = enrollment["first_name"].stringValue
        self.lastName = enrollment["last_name"].stringValue
        self.emailLevel = enrollment["email_level"].stringValue
        self.role = enrollment["role"].stringValue
        self.username = enrollment["username"].stringValue
        if let batman = UIImage(named: "batman.jpg") {
            self.picture = batman
        }
        
        if let loader = loader {
            loader.load(path: enrollment["picture"]["url"].stringValue) {
                [weak self] (data, status, error) in
                guard let this = self else { return }
                if let image = UIImage(data: data) {
                    this.picture = image
                }
            }
        }
    }
}
