//
//  EndPoints.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/23/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation

enum EndPoints {
    case Search
}

extension EndPoints {
    var path:String {
        let baseURL = "https://www.omdbapi.com"
        
        struct Section {
            static let search = "/?"
        }
        
        switch(self) {
        case .Search:
            return "\(baseURL)\(Section.search)"
            
        }
        
    }
    
}
