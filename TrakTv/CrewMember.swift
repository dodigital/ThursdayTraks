//
//  Crew.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 15/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class CrewMember: Person {

    var job : String =  ""
    var department : String = ""
    
    init(movieId : Int, name : String, job : String, department : String) {
        super.init(name: name, movieId: movieId)
        
        self.job = job
        self.department = department
    }
}
