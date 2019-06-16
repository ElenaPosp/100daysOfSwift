//
//  Person.swift
//  Project10
//
//  Created by Елена Поспелова on 16/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
