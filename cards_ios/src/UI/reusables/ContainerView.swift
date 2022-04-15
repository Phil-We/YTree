//
//  ContainerView.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 4/10/22.
//

import SwiftUI

struct Container<Content: View>: View {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment?
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content.frame(width: width, height: height, alignment: alignment ?? .center)
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Container(width: 200, height: 300, alignment: .topTrailing){
            Rectangle().fill(Color.blue).frame(width: 10, height: 10).padding().background(.red)
        }.background(.gray)
        
    }
}
