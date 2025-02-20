//
//  Course.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 14/11/24.
//

import Foundation

struct CourseModel: Codable, Hashable{
    let id: String
    var name: String
    var description: String
    var learningObjectives: String
    var schedule: String
    var prerequisites: String
    var materials: [String]
    var imageUrl: String
    var isFavorite: Bool?
    

    init(id: String = "",
         name: String = "",
         description: String = "",
         learningObjectives: String = "",
         schedule: String = "",
         prerequisites: String = "",
         materials: [String] = [],
         imageUrl: String = ""
         
         ) {
        self.id = id
        self.name = name
        self.description = description
        self.learningObjectives = learningObjectives
        self.schedule = schedule
        self.prerequisites = prerequisites
        self.materials = materials
        self.imageUrl = imageUrl
        
    }
}



