//
//  square.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/9/22.
//

import SwiftUI

class Square {
    var sideLength: CGFloat
    var innerRadius:CGFloat{
        return self.sideLength / 2
    }
    var outerRadius: CGFloat{
        return self.innerRadius * sqrt(2)
    }
    
    init(size: CGFloat) {
        self.sideLength = size
    }
    
    init(radius: CGFloat) {
        let size = radius * sqrt(2)
        self.sideLength = size
    }
    
}

