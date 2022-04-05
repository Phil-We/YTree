//
//  navBarAppearance.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 2/21/22.
//

import SwiftUI
struct NavBarAppearanceModifier: ViewModifier {
    init(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor?, hideSeperator: Bool){
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.backgroundColor = backgroundColor
        
        if hideSeperator {
            navBarAppearance.shadowColor = tintColor
        }
        
        if tintColor != nil {
            UINavigationBar.appearance().tintColor = UIColor.systemBackground
        }
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
    }
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationAppearance(backgroundColor: UIColor, foregroundColor: UIColor, tintColor: UIColor? = nil, hideSeperator: Bool = false) -> some View {
        self.modifier(NavBarAppearanceModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, hideSeperator: hideSeperator))
    }
}
