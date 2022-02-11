//
//  Course.swift
//  Networking
//
//  Created by Max Pavlov on 11.02.22.
//

import Foundation

struct Course: Decodable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
