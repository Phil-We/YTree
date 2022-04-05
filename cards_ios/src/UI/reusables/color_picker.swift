//
//  color_picker.swift
//  cards_ios
//
//  Created by Phil Weckenmann on 3/8/22.
//

import SwiftUI

struct ColorPickerSheet:View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var tag = 0
    @Binding var showPicker: Bool

    @StateObject var color: CustomColor = CustomColor(r: 1, g: 0, b: 0)
    @State private var selectedPalette: Int = -1

    var body: some View{

        VStack(spacing: 0) {
            tools()
                //.padding(.horizontal).padding(.vertical,8)
            if horizontalSizeClass == .regular {
                HStack (spacing: 30){
                    VStack{
                        
                        ZStack(alignment: .top) {
                            HSLPicker(color: color)
                            HStack{
                                Image(systemName: "eyedropper.halffull")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 25))

                                Spacer()
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.clear)
                                    .overlay(Circle().strokeBorder(Color.primary))
                                    .background(
                                        Rectangle()
                                            .fill(.red)
                                            .frame(width:2)
                                            .rotationEffect(.degrees(-45))
                                    )
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(color.toColor())
                                    .overlay(Circle().strokeBorder(Color.primary))
                            }
                        }
                        Slider(value: $color.alpha, in: 0...1)
                    }
                    VStack{
                        Picker("Slider", selection: $tag) {
                            Text("Color").tag(0)
                            Text("Palette").tag(1)
                            Text("Shading").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        switch tag{
                            case 0:
                                sliders()
                            case 1:
                                PaletteListView(color: color)
                            default:
                                ShadedColorView(color: color)
                        }
                    }//.padding(.leading)
                }
                .padding([.leading, .bottom, .trailing])
                .frame(width: 750, height: 400)
            } else {
                Picker("Slider", selection: $tag) {
                    Text("Color").tag(0)
                    Text("Palette").tag(1)
                    Text("Shading").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                
                //ScrollView(.vertical){
                    VStack{
                        switch tag{
                            case 0:
                            HStack {
                                Spacer()
                                HSLPicker(color: color).frame(width: 200, height: 200)//.fixedSize()
                                Spacer()
                            }
                            sliders(opacitySlider: true).frame(width: .infinity, height: .infinity)
                            case 1:
                                PaletteListView(color: color)
                            default:
                                ShadedColorView(color: color)
                        }
                    }.frame(width: .infinity, height: .infinity)
                //}.frame(width: .infinity, height: .infinity).padding(.top).ignoresSafeArea()
            }
        }
        //.frame(width: 750, height: 400)
        .padding()
        .background(.regularMaterial)//Color(uiColor: .systemGroupedBackground))
        
    }
    func tools() -> some View {
        HStack {
            Spacer()
            Button {self.showPicker = false} label: {
                Text("Done").fontWeight(.semibold)
            }
            .padding(.trailing)
        }
    }
    
    func sliders(opacitySlider: Bool = false) -> some View {
        let padd: CGFloat = 8
        return Form {
            if opacitySlider {
                HStack {
                    Text("alpha:").foregroundColor(.secondary)
                    Slider(value: $color.alpha, in: 0...1).padding(.horizontal, padd)
                    Text("\(color.alpha.percent())%").frame(width: 30)
                }
            }
            Section{
                HStack {
                    Text("H:").foregroundColor(.secondary)
                    Slider(value: $color.hue, in: 0...360).padding(.horizontal, padd)
                    Text("\(Int(color.hue))").frame(width: 30)
                }
                HStack {
                    Text("S:").foregroundColor(.secondary)
                    Slider(value: $color.saturation, in: 0...1).padding(.horizontal, padd)
                    Text("\(color.saturation.percent())%").frame(width: 30)
                }
                HStack {
                    Text("L:").foregroundColor(.secondary)
                    Slider(value: $color.lightness, in: 0...1).padding(.horizontal, padd)
                    Text("\(color.lightness.percent())%").frame(width: 30)
                }

            }
            Section{
                HStack {
                    Text("R:").foregroundColor(.secondary)
                    Slider(value: $color.red, in: 0...1).padding(.horizontal, padd)
                    Text(String(Int(color.red * 255))).frame(width: 30)
                }
                HStack {
                    Text("G:").foregroundColor(.secondary)
                    Slider(value: $color.green, in: 0...1).padding(.horizontal, padd)
                    Text(String(Int(color.green * 255))).frame(width: 30)
                }
                HStack {
                    Text("B:").foregroundColor(.secondary)
                    Slider(value: $color.blue, in: 0...1).padding(.horizontal, padd)
                    Text(String(Int(color.blue * 255))).frame(width: 30)
                }
            }
            Section{
                HStack {
                    Text("Hex:").foregroundColor(.secondary)
                    Spacer()
                    Text("#FF00FF")
                }
            }
    }
    }
}

struct PaletteListView: View {
    @StateObject private var paletteList = PaletteList([
        Palette(name: "Mono", CustomColor(r: 160/255, g: 100/255, b: 178/255).generateShades(n: 10, lighter: true)),
        Palette(name: "Mono", CustomColor(r: 160/255, g: 100/255, b: 178/255).generateShades(n: 10, lighter: false)),
        Palette(name: "Mono", CustomColor(r: 90/255, g: 186/255, b: 132/255).generateShades(n: 10, lighter: true)),
        Palette(name: "Mono", CustomColor(r: 90/255, g: 186/255, b: 132/255).generateShades(n: 10, lighter: false)),
    ])
    @ObservedObject var color: CustomColor
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                ForEach(paletteList.palettes){ palette in
                    PaletteView(palette: palette, color: color)
                }
            }
        }
    }
}
struct PaletteView: View {
    @ObservedObject var palette: Palette
    @State var selected: Int?
    @State private var dragged: (id: String, hsl: HSLV)?
    @State private var deleteEntered = false
    let layout = [GridItem(.adaptive(minimum: 30))]
    
    @ObservedObject var color: CustomColor
    let squareSize: CGFloat = 30
    
    var body: some View{

         VStack(alignment: .leading) {
             TextField("Palette Name", text: $palette.name)
                
            LazyVGrid(columns: layout) {
                ForEach(0..<palette.colors.count, id: \.self){ i in
                    let _color = palette.colors[i]

                    RoundedRectangle(cornerRadius: 2)
                        .fill(_color.hsl.toColor())
                        .frame(width: 30, height: 30)
                        .addBorder((selected == i) ? Color.accentColor : Color.clear, width: 3, cornerRadius: 2)
                        .onTapGesture {
                            withAnimation {
                                if selected != i { selected = i } else { selected = nil}
                            }
                            color.setHSLV(_color.hsl)
                        }
                        .onDrag({
                            dragged = _color
                            return NSItemProvider(contentsOf: URL(string: _color.id)!)!
                        })
                        .onDrop(of: [.url], delegate: DropViewDelegate(onDropEntered: {
                            if dragged == nil { return }
                            let draggedItemIndex = palette.colors.firstIndex { return $0.id == dragged?.id } ?? 0
                            let droppedItemIndex = palette.colors.firstIndex { return $0.id == _color.id   } ?? 0
                            
                            if draggedItemIndex != droppedItemIndex {
                                withAnimation { palette.colors.swapAt(draggedItemIndex, droppedItemIndex) }
                            }
                        }, didDrop: {self.dragged = nil}))
                }
                if (selected != nil) {
                    Button(role: .destructive) {
                        if !(0...palette.colors.count-1 ~= selected!){
                            selected = nil
                            return
                        }
                        withAnimation {
                            let _ = palette.colors.remove(at: selected!)
                            selected = nil
                        }
                    } label: {
                        //Image(systemName: "trash")
                        Image(systemName: "minus")
                        .frame(width: squareSize, height: squareSize)
                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder())
                    }/*
                    .scaleEffect(deleteEntered ? 1.6 : 1)
                    .onDrop(of: [.url], delegate: DropViewDelegate(onDropEntered: {
                        if dragged != nil  {
                            withAnimation { deleteEntered = true  }
                        }
                    }, onDropExited: {
                        if dragged != nil  {
                            withAnimation { deleteEntered = false  }
                        }
                    }, didDrop: {
                        withAnimation {
                            let draggedIndex = palette.colors.firstIndex { return $0.id == dragged?.id } ?? 0
                            let _ = palette.colors.remove(at: draggedIndex)
                            self.dragged = nil
                            self.selected = nil
                            self.deleteEntered = false
                        }
                    }))*/

                }
                Button {
                    let new = (id: UUID().uuidString, hsl: HSLV(h: color.hue, s: color.saturation, l: color.lightness))
                    palette.colors.append(new)
                } label: {
                        Image(systemName: "plus")
                        .frame(width: squareSize, height: squareSize)
                        .addBorder(Color.accentColor, cornerRadius: 2)
                        .foregroundColor(.accentColor)
                }
            }
        }.padding()
        .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
    }
}
struct ShadedColorView: View {
    @ObservedObject var color: CustomColor
    @State private var baseColor: CustomColor?
    var shades: [HSLV] {
        let col = baseColor ?? color
        let lighter = col.generateShades(n: 6, lighter: true).reversed()
        var darker = col.generateShades(n: 6, lighter: false)
        darker.removeFirst()
        return lighter + darker
    }
    @State private var focused: Int?
    @State private var didPickLocally: Bool = false
    var body: some View{
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<shades.count){ i in
                    let shadeHSL = shades[i]
                    shadeHSL.toColor().frame(height: 60)
                        .border((i == focused) ? Color.accentColor : Color.clear, width: 4)
                        .onTapGesture {
                            didPickLocally = true
                            color.setHSLV(shadeHSL)
                            focused = i
                            didPickLocally = false
                        }
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
        //.onChange(of: color) { newColor in
            // wenn die Farbe hier gesetzt wurde bleibt baseColor
            // wenn sie außerhalb gesetzt wurde update baseColor
        //}
    }
}

struct HSLPicker: View {
    @ObservedObject var color: CustomColor
    @State private var isDragging = false
    @State var offset: CGSize = CGSize(width: 1, height: 0.5)
    
    let relHeight: CGFloat = 0.8660254038  //  sqrt(3) / 2
    
    private var colors: [Color] {
        var result: [Color] = []
        
        for i in stride(from: 0, to: 360, by: 10) {
            let hue = Double(i) / 360
            result.append(Color(hue: hue, saturation: 1, brightness: 1))
        }
        return result
    }
    @State private var lastSaturation: CGFloat? = nil
    var body: some View {

        GeometryReader{ geo in

            let frameSize = min(geo.size.width, geo.size.height)
            let strokeWidth = frameSize * 0.0625
            let innerFrameSize = frameSize - (strokeWidth * 2)
            let triangleWidth = innerFrameSize * 0.75
            //let sideLength = relHeight * frameSize

            let offX = (-innerFrameSize * 0.75 * (1-CGFloat(color.saturation)))
            //let offY: CGFloat = (sideLength * 0.5 * maxY)

            ZStack {
                // MARK: Circle
                ZStack{
                    Circle()
                        .strokeBorder(AngularGradient(gradient: Gradient(colors: colors), center: .center, startAngle: .degrees(0), endAngle: .degrees(360)), lineWidth: strokeWidth)
                        .frame(width: frameSize, height: frameSize)
                    
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: strokeWidth*0.6, height: strokeWidth*0.6)
                        .offset(x: 0.5*(frameSize - strokeWidth))
                        .rotationEffect(.degrees(Double(color.hue)))
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let vector = CGVector(dx: value.location.x, dy: value.location.y)
                                    let radians = atan2(vector.dy, vector.dx)
                                    var angle = radians * 180 / .pi

                                    if (angle < 0){ angle += 360 }
                                    color.hue = Float(angle)
                                })
                        )
                }
                
                // MARK: Triangle
                ZStack{
                    ZStack{
                        RadialGradient(colors: [.black, .clear], center: UnitPoint(x: 0.25, y: 1-relHeight), startRadius: 0, endRadius: relHeight*innerFrameSize)
                        
                        RadialGradient(colors: [.white, .clear], center: UnitPoint(x: 0.25, y: relHeight), startRadius: 0, endRadius: relHeight*innerFrameSize)
                        
                        LinearGradient(colors: [Color(hue: Double(color.hue / 360), saturation: 1, brightness: 1), Color.clear], startPoint: .trailing, endPoint: UnitPoint(x: 0.25, y: 0.5))
                    }.clipShape(Polygon(sides: 3))//.blendMode(.screen)
                    
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: strokeWidth*0.3, height: strokeWidth*0.3)
                        .position(x: innerFrameSize, y: innerFrameSize/2)
                        .offset(x: offX, y: 0)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    if lastSaturation == nil { lastSaturation = CGFloat(color.hue) }

                                    let dx = value.translation.width

                                    let percentX = dx / triangleWidth

                                    let d = (percentX + lastSaturation!).inRange(max: 1)
                                    color.saturation = Float(d)// = HSL(h: color.hue, s: color.s, l: Float(d))//Float(d)

                                })
                                .onEnded({ value in
                                    lastSaturation = nil
                                })
                        )
                    
                }.frame(width: innerFrameSize, height: innerFrameSize)
                .rotationEffect(.degrees(Double(color.hue)))
                
            }.frame(width: frameSize, height: frameSize)
        }
        .padding(0.0)
    }
}

struct test: View{
    @StateObject var color: CustomColor = CustomColor(r: 1, g: 0, b: 0)
    @State var pal = Palette(name: "Mono", CustomColor(r: 160/255, g: 100/255, b: 178/255).generateShades(n: 10, lighter: true))
    
    @State var showPicker = true

    var body: some View{
        ZStack(alignment: .topTrailing) {
            Button("Tap me") {
                showPicker.toggle()
            }.popover(isPresented: $showPicker) {
                ColorPickerSheet(showPicker: $showPicker)
            }
        }
        //ColorPickerSheet(showPicker: .constant(true))
        //PaletteView(palette: $pal, color: color)
    }
}
struct color_picker_Previews: PreviewProvider {
    static var previews: some View {
        test().preferredColorScheme(.dark).previewDevice("iPad Pro (12.9-inch) (5th generation)").previewInterfaceOrientation(.portraitUpsideDown)

        test().previewDevice("iPhone 11 Pro").preferredColorScheme(.dark)
    }
}
