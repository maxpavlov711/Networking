//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Max Pavlov on 11.02.22.
//

import Foundation

struct WebsiteDescription: Decodable {
    
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
