//
//  ModelPerson.swift
//  CoreData
//
//  Created by Apple on 12/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
public enum entityName : String{
    case Lead = "Lead"
    case Project = "Project"
    
}

class ModelPerson {
    var name : String?
    var lastName : String?
}
