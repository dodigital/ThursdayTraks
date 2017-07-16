//
//  Person.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 14/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class CastMember: Person {
    
    var characterName : String? //Character name as played by Person*

    init(movieId : Int?, name : String?, characterName : String?) {
        super.init(name: name, movieId : movieId)
        
        self.characterName = characterName
    }

}
