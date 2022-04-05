//
//  custom_navigationView.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 2/16/22.
//

import SwiftUI

struct CustomNavBar: View {
    var title: String
    var trailing: [Button<AnyView>] = []
    var opaque: Bool = true
    var seperator: Color? = nil
    var body: some View{
        HStack{
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            ForEach(0..<trailing.count) { i in
                self.trailing[i]
                    .padding(.leading)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .background(.regularMaterial)
        .border(width: (seperator != nil) ? 1 : 0, edges: [.bottom], color: seperator ?? .clear)
    }
}

struct ExpandableNavBar<Content: View>: View {
    var title: String
    //var trailing: [Button<AnyView>] = []
    var opaque: Bool = true
    var seperator: Color? = nil
    @State var expanded: Bool = true
    @ViewBuilder let content: Content
    var body: some View{
            VStack{
                HStack{
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    //            ForEach(0..<trailing.count) { i in
                    //                self.trailing[i]
                    //                    .padding(.leading)
                    //            }
                    Button (action: expand, label: {
                        Image(systemName: self.expanded ? "cancel":"chevron.down")
                            //.rotationEffect(.degrees(self.expanded ? 180 : 0))
                            .padding(2)
                            .background(Color.accentColor.opacity(0.2))
                            .clipShape(Circle())
                    
                    })
                    
                }
                if self.expanded {
                    Divider()
                    content
                        .padding(.top)
                    //.transition(.opacity.animation(.easeInOut.delay(0.3)))
                        .transition(.asymmetric(insertion: .opacity.animation(.easeInOut.delay(0.3)), removal: .move(edge: .top).combined(with: .opacity)))
                    
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(.regularMaterial).ignoresSafeArea()
            //.background(BlurView(style: .systemMaterial).ignoresSafeArea(edges: .top))
            .border(width: (seperator != nil) ? 1 : 0, edges: [.bottom], color: seperator ?? .clear)
            
    }
    func expand() {
        print("expand")
        withAnimation {
            self.expanded.toggle()
        }
        
    }
}

struct Custom_navigationView<Content: View>: View {
    var title: String
    let trailing: [Button<AnyView>]? //= []
    @State private var showingPopover = false
    @ViewBuilder let content: Content
    var body: some View {
        content
            .safeAreaInset(edge: .top) {
                CustomNavBar(title: title, trailing: trailing ?? []
                    )
            }
    }
}
