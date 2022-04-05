//
//  subject_card.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 2/13/22.
//

import SwiftUI

struct Subject_card: View {
    var color: Color
    var size: Int
    var icon:String
    var title: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            
            HStack{
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(minWidth: 70, idealWidth: 100, maxWidth: 130)
                
                Spacer()
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size:35, weight: .bold, design: .rounded))
                
            }.padding(.horizontal)
        }
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: regularCornerRadius))
        
    }
}

struct subject_card_Previews: PreviewProvider {
    static var previews: some View {
        Subject_card(color: Color.yellow, size: 3, icon: "function", title: "dsfas")
    }
}//*/
