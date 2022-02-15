//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Max Pavlov on 15.02.22.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        request(url, method: .get).responseJSON { response in
            print(response)
        }
    }
}


