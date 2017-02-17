//
//  Assignment.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/16/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation

class Assignment {
    var id: String
    var maxPoints: String
    var extraCreditAllowed: Bool
    var name: String
    var abbreviatedName: String
    var emailNotification: Bool
    var sortOrder: String
    var computeFunc: String
    var displayType: String
    var dueDate: String
    var userPermissions: Permissions
    var studentPermissions: Permissions?
    var scores: [Score]
    
    init(assignment: JSON) {
        self.id = assignment["id"].stringValue
        self.maxPoints = assignment["max_points"].stringValue
        self.extraCreditAllowed = assignment["extra_credit_allowed"].boolValue
        self.name = assignment["name"].stringValue
        self.abbreviatedName = assignment["abbreviated_name"].stringValue
        self.emailNotification = assignment["email_notification"].boolValue
        self.sortOrder = assignment["sort_order"].stringValue
        self.computeFunc = assignment["compute_func"].stringValue
        self.displayType = assignment["display_type"].stringValue
        self.dueDate = assignment["due_date"].stringValue
        self.userPermissions = Permissions(permissions: assignment["permissions"])
        if let studentPermissions = assignment["student_permissions"] {
            self.studentPermissions = Permissions(permissions: studentPermissions)
        }
        if let scores = assignment["scores"].array {
            self.scores = [Score]()
            for score in scores {
                let myScore = Score(score: score)
                self.scores.append(myScore)
            }
        }
    }
    
}

internal class Permissions {
    var id: String
    var person: String
    var visible: Bool
    var viewFiles: Bool
    var viewStats: Bool
    var viewHistogram: Bool
    var viewPermissions: Bool
    var create: Bool
    var change: Bool
    var viewComputedBy: Bool
    
    init(permissions: JSON) {
        self.id = permissions["id"].stringValue
        self.person = permissions["person"].stringValue
        self.visible = permissions["visible"].boolValue
        self.viewFiles = permissions["view_files"].boolValue
        self.viewStats = permissions["view_stats"].boolValue
        self.viewHistogram = permissions["view_histogram"].boolValue
        self.viewPermissions = permissions["view_permissions"].boolValue
        self.create = permissions["create"].boolValue
        self.change = permissions["change"].boolValue
        self.viewComputedBy = permissions["view_computed_by"].boolValue
    }
}

internal class Score {
    var counts: Bool
    var id: String
    var score: String
    var displayScore: String
    var postDate: String
    var feedback: File?
    var studentWork: File?
    
    init(score: JSON) {
        self.counts = score["counts"].boolValue
        self.id = score["id"].stringValue
        self.score = score["score"].stringValue
        self.displayScore = score["display_score"].stringValue
        self.postDate = score["post_date"].stringValue
        if let feedback = score["feedback"] {
            self.feedback = File(file: feedback)
        }
        if let studentWork = score["student_work"] {
            self.studentWork = File(file: studentWork)
        }
    }
}

internal class File {
    var id: String
    var mimeType: String
    var fileExtension: String
    var url: String
    
    init(file: JSON) {
        self.id = file["id"].stringValue
        self.mimeType = file["mimetype"].stringValue
        self.fileExtension = file["file_extension"].stringValue
        self.url = file["url"].stringValue
    }
}
