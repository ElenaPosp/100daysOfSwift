//
//  Structs.swift
//  Project7
//
//  Created by Елена Поспелова on 03/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
