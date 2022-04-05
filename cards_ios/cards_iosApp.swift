//
//  cards_iosApp.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 2/13/22.
//

import SwiftUI

@main
struct cards_iosApp: App {
    //let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            test()
                //.environmentObject(dialog_controller)
            //TestView()//RootDirectory()//Custom_navigationView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//struct MainInterface: View {
//    @State private var showingPopover = false
//    @State private var dialog: AnyView? = nil
//    @State private var showDialog: Bool = false
//    @State private var text: String = ""
//    var body: some View{
//        ZStack{
//            Custom_navigationView(title: "Canvas", trailing:[
//                Button(action: {self.showingPopover.toggle()}, label: {
//                    AnyView(
//                        Image(systemName: "plus.circle.fill")
//                            .foregroundColor(Color.accentColor.opacity(0.7))
//                            .font(.system(size: 30))
//                            .popover(isPresented: $showingPopover) {ColorPickerSheet(showPicker: $showingPopover).frame(width: 400, height: 300)}
//                    )})]
//            ){
//                VStack{
//                    Spacer()
//                    Button("showAlert", action: { self.showDialog.toggle()})
//                    Spacer()
//                }
//                    
//                }
//        }
//    }
//}
//
//struct MainInterFacePrev: PreviewProvider{
//    static var previews: some View{
//        MainInterface()
//    }
//}
/*
struct TestView: View{
    @State var color: CustomColor = CustomColor(red: 255, green: 0, blue: 0)
    @State var showingPopover = false
    var body: some View{
        Custom_navigationView(title: "Canvas", trailing:[
            Button(action: {self.showingPopover.toggle()}, label: {
                AnyView(
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 30))
                        .popover(isPresented: $showingPopover) {ColorPickerSheet(showPicker: $showingPopover)}
                )})]
        ){
                HStack {
                    ScrollView{
                        ForEach(self.color.generateShades(n: 10, lighter: false), id: \.self){color in
                            Rectangle()
                                .frame(width: 300, height: 200)
                                .foregroundColor(color)
                            
                        }
                    }
                    ScrollView{
                        ForEach(self.color.generateShades(n: 10, lighter: true), id: \.self){color in
                            Rectangle()
                                .frame(width: 300, height: 200)
                                .foregroundColor(color)
                            
                        }
                    }
                }
                
            }
    }
}
*/
