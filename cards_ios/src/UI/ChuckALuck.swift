//
//  ChuckALuck.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/29/22.
//

import SwiftUI
import Combine

struct ChuckALuck: View {
    @StateObject var dice1 = Dice()
    @StateObject var dice2 = Dice()
    @StateObject var dice3 = Dice()
    @State private var credits = 1000
    var body: some View {
        ZStack {
            Color(red:0.1,green:0.7, blue: 0.1).ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                        
                    Text("Credits: \(credits)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Image(systemName: "star.circle")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                }.foregroundColor(.white)
                Spacer()
                HStack(alignment: .center, spacing: 30){
                    DiceView(dice: dice1)
                    DiceView(dice: dice2)
                    DiceView(dice: dice3)
                }.padding(.top)
                .frame(width: UIScreen.main.bounds.width * 0.8).padding(.bottom,30)
                Spacer()
                CAlTable(credits: $credits, rollDices: {
                    withAnimation{
                        dice1.roll()
                        dice2.roll()
                        dice3.roll()
                    }
                    return [ dice1.state, dice2.state, dice3.state ]
                })
            }.padding(20)
        }
    }
}
enum DiceState: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
}

class Dice: Identifiable, ObservableObject {
    var id = UUID()
    @Published var state = 6
    
    func roll() {
        self.state = Int.random(in: 1...6)
    }
}

struct DiceView: View {
    let layout = [GridItem](repeating: GridItem(.flexible()), count: 3)
    var dice: Dice
    var body: some View {
            GeometryReader{ geo in
                let width = geo.size.width
                let innerWidth = width * 0.7
                let frameWidth = innerWidth/3
                LazyVGrid(columns: layout, spacing: 0) {
                    let visibilities = getEyes()
                    ForEach(0..<9){ i in
                        let isVisible = visibilities[i]
                        Circle()
                            .fill(.black)
                            .padding(frameWidth/8)
                            .frame(width: frameWidth, height: frameWidth)
                            .opacity(isVisible ? 1 : 0)
                    }
                }
                .frame(width: innerWidth, height: innerWidth)
                .padding(width*0.15)
                .background(Color.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 20))
                
            }
    }

    func getEyes() -> [Bool] {
        switch dice.state {
        case 1:
            return [false,false,false,false,true,false,false,false,false]
        case 2:
            return [true,false,false,false,false,false,false,false,true]
        case 3:
            return [true,false,false,false,true,false,false,false,true]
        case 4:
            return [true,false,true,false,false,false,true,false,true]
        case 5:
            return [true,false,true,false,true,false,true,false,true]
        default:
            return [true,false,true,true,false,true,true,false,true]
        }
    }
    
}




struct CAlTable: View {
    @Binding var credits: Int
    @State private var fields: [Int] = [0,0,0,0,0,0]
    @State private var selected: Int?
    @State private var showingAlert = false
    @State private var customBet: Int = 0
    let rollDices: () -> [Int]
    
    func place(bet: Int) {
        //assert((onField >= 1) && (onField <= 6), "Field cant be accessed")
        if (credits - bet) < 0{
            showingAlert = true
            return
        }
        if self.selected != nil{
            fields = [0,0,0,0,0,0]
            fields[self.selected!] = bet
        }
    }
    
    var body: some View {
        let spacing: CGFloat = 10
        let frameWidth = UIScreen.main.bounds.width*0.9 - 2 * spacing
        let height = frameWidth / 3 * 2
        let layout = [GridItem](repeating: GridItem(.flexible()), count: 3)
        ZStack {
            VStack {
                LazyVGrid(columns: layout, spacing: spacing) {
                    ForEach(0..<6){ i in
                        let isSelected = (self.selected == i)
                        VStack{
                            Text(String(i+1)).font(.system(size: 70, weight: .heavy, design: .rounded))
                                .opacity(0.8)
                            
                            Text("\(self.fields[i])$").font(.system(size: 40, weight: .bold, design: .monospaced))
                        }.padding(.vertical).frame(width: frameWidth/3).addBorder(Color.white, cornerRadius: 20)
                            .background(Color.white.opacity(isSelected ? 0.5 : 0), in: RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.white)
                            .onTapGesture {
                                if  isSelected {
                                    self.selected = nil
                                } else{
                                    self.selected = i
                                }
                            }
                        
                    }
                }
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        place(bet: 200)
                    } label: {
                        Label("200", systemImage: "star.circle")
                            .foregroundColor(.yellow)
                            .font(.title3)
                            .padding()
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }.disabled(selected == nil)
                    Spacer()
                    TextField("Bet", value: $customBet, format: .number)
                        .keyboardType(.numberPad)
                        //.padding(.horizontal)
                        .frame(height: 40)
                        .background(.clear)
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.white))
                        .onChange(of: customBet, perform: { amount in
                            place(bet: amount)
                        })
                        .disabled(selected == nil)
                        .padding()
                    Spacer()
                    Button {
                        let _ = rollDices()
                    } label: {
                        Label("skip", systemImage: "xmark.circle")
                            .foregroundColor(.red)
                            .font(.title3)
                            .padding()
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    
                }
                Button {
                    play()
                } label: {
                    Label("Play", systemImage: "dice")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                        .background(.blue.opacity(0.5))
                        .clipShape(Capsule())
                }
            
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Game Over"), message: Text("You have not enough credits to place the bet."), dismissButton: .cancel())
        }
    }
    func play() {
        let bet: Int = {
            for field in fields {
                if field != 0 { return field}
            }
            return 0
        }()
        let result = rollDices()
        let amount: Int =  {
            var val = 0
            for field in result{
                val += fields[field-1]
            }
            return val
        }()
        
        if amount == 0 {
            if (credits - bet) <= 0 {
                credits = 0
                showingAlert = true
            } else{
                credits -= bet
            }
        } else {
            credits += amount
        }
    }
}

struct ChuckALuck_Previews: PreviewProvider {
    static var previews: some View {
        ChuckALuck()
    }
}
