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
            tools
            
            //(horizontalSizeClass == .compact) ? compactLayout : regularLayout
            switch horizontalSizeClass {
            case .compact:
                compactLayout
            case .regular:
                regularLayout
            default:
                compactLayout
            }
            /*
            if horizontalSizeClass == .compact {
                HStack (spacing: 30){
                    VStack{
                        
                        ZStack(alignment: .top) {
                            ColorWheel(color: color)
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
                                ColorWheel(color: color).frame(width: 200, height: 200)//.fixedSize()
                                Spacer()
                            }
                            sliders(opacitySlider: true).frame(maxWidth: .infinity, maxHeight: .infinity)
                            case 1:
                                PaletteListView(color: color)
                            default:
                                ShadedColorView(color: color)
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                //}.frame(width: .infinity, height: .infinity).padding(.top).ignoresSafeArea()
            }
            */
        }
        .padding()
        .background(.regularMaterial)//Color(uiColor: .systemGroupedBackground))
        
    }
    var tools: some View {
        HStack {
            Spacer()
            Button {self.showPicker = false} label: {
                Text("Done").fontWeight(.semibold)
            }
            .padding(.trailing)
        }
    }
    
    var compactLayout: some View {
        VStack{
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
                            ColorWheel(color: color).frame(width: 200, height: 200)//.fixedSize()
                            Spacer()
                        }
                        sliders(opacitySlider: true).frame(maxWidth: .infinity, maxHeight: .infinity)
                        case 1:
                            PaletteListView(color: color)
                        default:
                            ShadedColorView(color: color)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    var regularLayout: some View {
        HStack (spacing: 30){
            VStack{
                
                ZStack(alignment: .top) {
                    ColorWheel(color: color)
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

struct ColorWheel: View {
    @ObservedObject var color: CustomColor
    
    var body: some View {

        GeometryReader { geometry in
            ColorWheelView(color: color, viewSize: geometry.size)
        }
    }
    
    private struct ColorWheelView: View {
        @ObservedObject var color: CustomColor
        @State private var isDragging: Bool = false
        @State private var preDrag = (saturation: CGFloat(1), lightness: CGFloat(0.5))
//        @State private var preDragSaturation: CGFloat? = nil
//        @State private var preDragLightness: CGFloat? = nil
        
        var viewSize: CGSize
        
        private var squareSize: CGFloat{  min(viewSize.width, viewSize.height) }
        private var strokeWidth: CGFloat{ squareSize * 0.0625 }
        private var innerSquareSize: CGFloat{ squareSize - (strokeWidth * 2) }
        private var triangleFrame: CGSize{ CGSize(width: innerSquareSize * pow(factor, 2), height: factor * innerSquareSize) }
        private var dragCircleSize: CGFloat { innerSquareSize * 0.04 }
        
        private let factor: CGFloat = 0.8660254038  //  sqrt(3) / 2
        private let angularGradient: AngularGradient = {
            var _colors: [Color] = []
            
            for i in stride(from: 0, to: 360, by: 10) {
                let hue = Double(i) / 360
                _colors.append(Color(hue: hue, saturation: 1, brightness: 1))
            }
            return AngularGradient(gradient: Gradient(colors: _colors), center: .center, startAngle: .degrees(0), endAngle: .degrees(360))
        }()
        var body: some View{
            ZStack(alignment: .center) {
                // MARK: Circle
                circle
                
                // MARK: Triangle
                triangle
                    .frame(width: innerSquareSize, height: innerSquareSize)
                    .rotationEffect(.degrees(Double(color.hue)))
                
            }.frame(width: squareSize, height: squareSize)
        }
        var circle: some View{
            ZStack{
                Circle()
                    .strokeBorder(angularGradient, lineWidth: strokeWidth)
                    .frame(width: squareSize, height: squareSize)
                
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: strokeWidth*0.6, height: strokeWidth*0.6)
                    .offset(x: 0.5*(squareSize - strokeWidth))
                    .rotationEffect(.degrees(Double(color.hue)))
                    .gesture(DragGesture().onChanged(setHue))
            }
        }
        
        var triangle: some View{
            HStack{
                Spacer()
           // Group {
                ZStack {
                    ZStack{
                        LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottom)
                        RadialGradient(colors: [Color(hue: Double(color.hue / 360), saturation: 1, brightness: 1), .clear], center: UnitPoint(x: 1, y: 0.5), startRadius: 0, endRadius: triangleFrame.width)
                    }.clipShape(Triangle())
                    Circle()
                        .fill(color.toColor(), strokeBorder: Color.white, lineWidth: dragCircleSize / 6)
                        .frame(width: dragCircleSize, height: dragCircleSize)
                        .position(getPosition(s: CGFloat(color.saturation), l: CGFloat(color.lightness)))
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged(setPosition)
                                .onEnded({ _ in isDragging = false })
                        )
                }.frame(width: triangleFrame.width, height: triangleFrame.height)
            }.frame(width: innerSquareSize, height: innerSquareSize, alignment: .trailing)

        }
        
        func setHue(_ value: DragGesture.Value) {
            let vector = CGVector(dx: value.location.x, dy: value.location.y)
            let radians = atan2(vector.dy, vector.dx)
            var angle = radians * 180 / .pi

            if (angle < 0){ angle += 360 }
            color.hue = Float(angle)
        }
        
        func setPosition(_ value: DragGesture.Value) {
            if !isDragging {
                startGesture()
                return
            }
            
            // lightness --> saturation
            
            // !!! IMPORTANT !!!
            // switched width / height to match coordinate system
            let relativeDrag = (dx: (value.translation.height / triangleFrame.height), dy: (value.translation.width / triangleFrame.width))
            
            let relX = (preDrag.lightness + relativeDrag.dx).inRange(max: 1)
            let relY = (preDrag.saturation + relativeDrag.dy).inRange(max: 1)
            
            if relY == 1 {
                color.saturation = 1
                color.lightness = 0.5
                return
            }
            // m = 2       y != relY       x = l
            // y = ml      y = m - ml
            
            // x1 = y/m             =>      y / 2
            // x2 = (m - y) / m     => 1 - (y / 2)
            let _x1 = relY / 2
            let border = (x1: _x1, x2: 1 - _x1)
            
            
            if border.x1...border.x2 ~= relX {
                if relY == 0 {
                    color.saturation = 0
                    color.lightness = Float(relX)
                } else{
                    let res = getSatAndLightFromPoint(relX: Float(relX), relY: Float(relY))
                    color.saturation = res.sat
                    color.lightness = res.light
                }
            } else if relX < border.x1{
                color.saturation = 1
                color.lightness = Float(border.x1)
            } else if relX > border.x2{
                color.saturation = 1
                color.lightness = Float(border.x2)
            }
            
        }
        func startGesture(){
            let sat = CGFloat(color.saturation)
            let light = CGFloat(color.lightness)
            preDrag = (saturation: sat, lightness: light)
            isDragging = true
        }

        
        func getPosition(s: CGFloat, l: CGFloat) -> CGPoint {
            let m: CGFloat = 2
            let g_l: CGFloat = {
                if l < 0.5 {
                    return m * l
                } else if l == 0.5 {
                    return 1
                } else { //if l > 0.5
                    return 2 - (m * l)
                }
            }()
            let f_sl: CGFloat = s * g_l
            return UnitPoint(x: f_sl, y: l).toCGPoint(triangleFrame.width, triangleFrame.height)
        }
    }
}

func getSatAndLightFromPoint(relX: Float, relY: Float) -> (sat: Float, light: Float){
    // gerade durch 2 Punkte um sättigung zu bekommen
    if relX == 0.5 {
        return (relY, 0.5)
    }
    let dragInLeftHalf: Bool = relX < 0.5
    
    
    let m =  dragInLeftHalf ? (relY/relX) : (-relY/(1-relX))
    let linearEquation = makeLinearEquation(m: m, c: dragInLeftHalf ? 0 : -m)
    let sat = linearEquation(0.5)
    let _l = relY / (sat * 2)
    let light = dragInLeftHalf ? _l : 1-_l
    return (sat, light)
}

struct test: View{
    @StateObject var color: CustomColor = CustomColor(r: 1, g: 0, b: 0)
    @State var pal = Palette(name: "Mono", CustomColor(r: 160/255, g: 100/255, b: 178/255).generateShades(n: 10, lighter: true))
    
    @State var showPicker = true

    var body: some View{
        ZStack(alignment: .topTrailing) {
            Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
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
struct testTriangle: View{
    @StateObject var color = CustomColor(r: 1, g: 0, b: 0)
    @State private var size: CGFloat = 600
    var body: some View{
            ColorWheel(color: color).frame(width: size, height: size)
    }
}
struct color_picker_Previews: PreviewProvider {
    static var previews: some View {
        testTriangle().preferredColorScheme(.dark).previewDevice("iPad Pro (12.9-inch) (5th generation)").previewInterfaceOrientation(.portraitUpsideDown)
        //test()
       // test().previewDevice("iPhone 11 Pro").preferredColorScheme(.dark)
    }
}
