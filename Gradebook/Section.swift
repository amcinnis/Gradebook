//
//  Section.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/16/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation

class Section {
    
    var id: String
    var polynum: String
    var term: String
    var termName: String
    var dept: String
    var course: String
    var title: String
    var firstDay: String
    var lastDay: String
    
    init(section: JSON) {
        self.id = section["id"].stringValue
        self.polynum = section["polynum"].stringValue
        self.term = section["term"].stringValue
        self.termName = section["termName"].stringValue
        self.dept = section["dept"].stringValue
        self.course = section["course"].stringValue
        self.title = section["title"].stringValue
        self.firstDay = section["first_day"].stringValue
        self.lastDay = section["last_day"].stringValue
    }
}
