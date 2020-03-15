//
//  ContentView.swift
//  WorkoutActivityRings
//
//  Created by Froehlich, Steffen on 15.03.20.
//  Copyright © 2020 Froehlich, Steffen. All rights reserved.
//

import SwiftUI

extension Color {
    public static var outlineRed: Color {
        self.init(#colorLiteral(red: 0.1317308247, green: 0.001112335827, blue: 0.01333586965, alpha: 1))
    }
    public static var darkRed: Color {
        self.init(#colorLiteral(red: 0.8785472512, green: 0, blue: 0.07300490886, alpha: 1))
    }
    public static var lightRed: Color {
        self.init(#colorLiteral(red: 0.930870235, green: 0.2051250339, blue: 0.4874394536, alpha: 1))
    }
    public static var lightRedCircleEnd: Color {
        self.init(#colorLiteral(red: 0.9265889525, green: 0.2061708272, blue: 0.4833006263, alpha: 1))
    }
    public static var outlineGreen: Color {
        self.init(#colorLiteral(red: 0.03259197623, green: 0.1287679374, blue: 0.001097879023, alpha: 1))
    }
    public static var darkGreen: Color {
        self.init(#colorLiteral(red: 0.1992103457, green: 0.8570511937, blue: 0, alpha: 1))
    }
    public static var lightGreen: Color {
        self.init(#colorLiteral(red: 0.6962995529, green: 0.9920799136, blue: 0, alpha: 1))
    }
    public static var lightGreenCircleEnd: Color {
        self.init(#colorLiteral(red: 0.6870413423, green: 0.9882482886, blue: 0.002495098161, alpha: 1))
    }
    public static var outlineBlue: Color {
        self.init(#colorLiteral(red: 0.00334665901, green: 0.107636027, blue: 0.1323693693, alpha: 1))
    }
    public static var darkBlue: Color {
        self.init(#colorLiteral(red: 0, green: 0.7215889096, blue: 0.8796694875, alpha: 1))
    }
    public static var lightBlue: Color {
        self.init(#colorLiteral(red: 0.01598069631, green: 0.9643213153, blue: 0.8177756667, alpha: 1))
    }
    public static var lightBlueCircleEnd: Color {
        self.init(#colorLiteral(red: 0.01418318599, green: 0.9563375115, blue: 0.8142204285, alpha: 1))
    }
    public static var blueStandBarInactiveTop: Color {
        self.init(#colorLiteral(red: 0, green: 0.29171592, blue: 0.2454764843, alpha: 1))
    }
    public static var blueStandBarInactiveBottom: Color {
        self.init(#colorLiteral(red: 0, green: 0.2227569222, blue: 0.2638536096, alpha: 1))
    }
    public static var blueStandBarActiveTop: Color {
        self.init(#colorLiteral(red: 0, green: 0.9733348489, blue: 0.8126369119, alpha: 1))
    }
    public static var blueStandBarActiveBottom: Color {
        self.init(#colorLiteral(red: 0, green: 0.7377325892, blue: 0.887093246, alpha: 1))
    }
}

enum RingDiameter: CGFloat {
    case small = 0.34
    case medium = 0.58
    case big = 0.82
    case calculated = 1.0
}

// TODO: use ColorType Enum for selecting ring color later,
// currently it's done via direct array access
enum ColorType: String {
    case base
    case light
    case outline
}

struct ActivityArrow: View {
    var doubleArrow: Bool = false
    private let startPoint = CGPoint(x: 20, y: 20)

    var body: some View {
        return Path { p in
            p.move(to: startPoint)
            p.addLine(to: CGPoint(x: 0, y: 20))

            p.move(to: startPoint)
            p.addLine(to: CGPoint(x: 12, y: 8))

            p.move(to: startPoint)
            p.addLine(to: CGPoint(x: 12, y: 32))

            if doubleArrow {
                p.move(to:  CGPoint(x: startPoint.x + 8, y: startPoint.y))
                p.addLine(to: CGPoint(x: 20, y: 32))

                p.move(to:  CGPoint(x: startPoint.x + 8, y: startPoint.y))
                p.addLine(to: CGPoint(x: 20, y: 8))
            }
        }
        .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round))
//        .scale(2)
    }
}

//struct ActivityArrow_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            ActivityArrow()
//            ActivityArrow(doubleArrow: true)
//        }
//        .padding()
//    }
//}

struct StandDataPoint: Identifiable {
    let id = UUID()
    let hour: Int // TODO enhance for range (0 ... 24)
    let active: Bool
}

struct StandBar: View {
    var dataPoint: StandDataPoint
    var width: CGFloat

    var body: some View {
        VStack {
            Capsule()
                .size(width: 10, height: 60)
                .frame(width: width, height: 60)
                // workaround - currently using Xcode 11.3.1
                // - fill doesn't work with frame property, insert overlay
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .fill(dataPoint.active
                        ? LinearGradient(
                            gradient: Gradient(colors: [Color.blueStandBarActiveTop, Color.blueStandBarActiveBottom]), startPoint: .top, endPoint: .bottom)
                        : LinearGradient(
                            gradient: Gradient(colors: [Color.blueStandBarInactiveTop, Color.blueStandBarInactiveBottom]), startPoint: .top, endPoint: .bottom)
                    )
                )
            
//            if dataPoint.hour % 6 == 0 {
//                Text("\(dataPoint.hour):00")
//                    .frame(width: 40, alignment: .leading)
//                    .font(.footnote)
//                    .foregroundColor(.white)
////                  .opacity(dataPoint.hour % 6 == 0 ? 1 : 0)
//            }
        }
//        .frame(width: width , height: 75, alignment: .top)

    }
}

struct BarChartStand: View {
    @Binding var progress: CGFloat

    private var standItems: [StandDataPoint] = []
    
    public init(progress: Binding<CGFloat>) {
        self._progress = progress
        let progressHour: Int = Int(floor(12 * self.progress))

        for hour in 0...23 {
            self.standItems.append(.init(hour: hour, active: hour < progressHour))
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack (alignment: .top) {
                    ForEach(self.standItems) { standItem in
                        StandBar(dataPoint: standItem,
                                 // avail. size - thickness of space between
                                 width: (geometry.size.width - 25 * 7.5) / 24)
                    }
                }

                HStack {
                    Text("00:00")
                    Spacer()
                    Text("06:00")
                    Spacer()
                    Text("12:00")
                    Spacer()
                    Text("18:00")
                    Spacer(minLength: geometry.size.width / 4.3)
                }
                .frame(width: geometry.size.width, alignment: .bottom)
                .foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                .font(.system(size: 12))
            }
        }
    }
}

struct ActivityRing: View {
    @Binding var progress: CGFloat

    let ringDia: RingDiameter

    // offset for closing circle and arrows
    private var fullCircleDotOffset: CGFloat { return 350 * -ringDia.rawValue / 2 }
    private let ringThickness: CGFloat = 40.0

    // TODO somehow Dict access doesn't work well in SwiftUI?!
//    private var ringColor: [ColorType: Color] {
//        get {
//            switch ringDia {
//            case .big: return [.base: Color.darkRed,
//                               .light: Color.lightRed,
//                               .outline: Color.outlineRed]
//            case .medium: return [.base: Color.darkGreen,
//                                  .light: Color.lightGreen,
//                                  .outline: Color.outlineGreen]
//            case .small: return [.base: Color.darkBlue,
//                                 .light: Color.lightBlue,
//                                 .outline: Color.outlineBlue]
//            }
//        }
//    }

    private var ringColor: [Color] {
        get {
            switch ringDia {
            case .big: return [Color.darkRed,
                               Color.lightRed,
                               Color.lightRedCircleEnd,
                               Color.outlineRed]
            case .medium: return [Color.darkGreen,
                                  Color.lightGreen,
                                  Color.lightGreenCircleEnd,
                                  Color.outlineGreen]
            case .small: return [Color.darkBlue,
                                 Color.lightBlue,
                                 Color.lightBlueCircleEnd,
                                 Color.outlineBlue]
            default: return [Color.primary, Color.pink, Color.purple, Color.secondary]
                
            }
        }
    }

    var body: some View {
        ZStack {
            if self.progress < 0.98 {
                // background ring
                Circle()
                    .scale(self.ringDia.rawValue)
                    .stroke(self.ringColor[3], lineWidth: self.ringThickness)

                // Activity Ring
                Circle()
                    .scale(self.ringDia.rawValue)
                    .trim(from: 0, to: self.progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
                    .rotationEffect(.degrees(-90.0))

                // fix overlapping gradient from full cycle
                Circle()
                    .frame(width: self.ringThickness, height: self.ringThickness)
                    .foregroundColor(self.ringColor[0])
                    .offset(y: self.fullCircleDotOffset)

            } else {
                // Activity Ring
                Circle()
                    .scale(self.ringDia.rawValue)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [self.ringColor[0], self.ringColor[1]]),
                            center: .center,
                            startAngle: .degrees(0.0),
                            endAngle: .init(degrees: 360.0)
                        ),
                        style: StrokeStyle(lineWidth: self.ringThickness, lineCap: .round))
                    .rotationEffect(.degrees((360 * Double(self.progress)) - 90))

                // TODO let Circle overlap of underlying ring
                Circle()
                    .frame(width: self.ringThickness, height: self.ringThickness)
                    .offset(y: self.fullCircleDotOffset)
                    .foregroundColor(self.ringColor[2]) // TODO insert linear Gradient
//                    .overlay(Circle()
//                        .offset(y: self.fullCircleDotOffset)
//                        .fill(LinearGradient(gradient: Gradient(colors: [ringColor[2], ringColor[1]]),startPoint: .leading, endPoint: .trailing))
//                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: self.ringThickness / 4, y: 0)
                    .rotationEffect(.degrees(360 * Double(self.progress)))


            }

            // Activity Arrows
            ActivityArrow(doubleArrow: self.ringDia == .medium ? true : false)
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .rotationEffect(self.ringDia == .small
                    ? .degrees(-90)
                    : .degrees(0)
                )
                .offset(
                    x: self.ringDia == .small ? 0 : 5,
                    y: self.ringDia == .small ? -70 : self.fullCircleDotOffset)

        }
        .frame(width: 350, height: 350)
    }
}

struct ActivityRings: View {
    @Binding var big: CGFloat
    @Binding var medium: CGFloat
    @Binding var small: CGFloat

    var body: some View {
        ZStack {
            // RED ring
            ActivityRing(progress: self.$big, ringDia: .big)
            // GREEN ring
            ActivityRing(progress: self.$medium, ringDia: .medium)
            // BLUE ring
            ActivityRing(progress: self.$small, ringDia: .small)
        }
    }
}

struct CirclesWorkout: View {
    @State private var progressBig: CGFloat = 1.25
    @State private var progressMedium: CGFloat = 1.26
    @State private var progressSmall: CGFloat = 1.857

    var body: some View {
        ZStack {

            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                BarChartStand(progress: $progressSmall)
                
                ActivityRings(big: $progressBig,
                              medium: $progressMedium,
                              small: $progressSmall)
                    .onTapGesture {
                        withAnimation {
                            self.progressBig = CGFloat.random(in: 0.0...3.5)
                            self.progressMedium = CGFloat.random(in: 0.0...3.5)
                            self.progressSmall = CGFloat.random(in: 0.0...2)
                        }
                  }
                
                Spacer()
                
                // RED circle
                HStack(alignment: .center, spacing: 5.0) {
                    Text("RED").font(.caption).foregroundColor(.white)
                    Slider(value: $progressBig, in: 0...3.5, step: CGFloat(0.01))

                }.padding([.horizontal, .top])

                // GREEN circle
                HStack(alignment: .center, spacing: 5.0) {
                    Text("GREEN").font(.caption).foregroundColor(.white)
                    Slider(value: $progressMedium, in: 0...3.5, step: CGFloat(0.01))
                }.padding([.horizontal])

                // BLUE circle
                HStack(alignment: .center, spacing: 5.0) {
                    Text("BLUE").font(.caption).foregroundColor(.white)
                    Slider(value: $progressSmall, in: 0...2, step: CGFloat(0.01))
                }.padding([.horizontal, .bottom])
            }
        }
    }
}

struct CirclesWorkout_Previews: PreviewProvider {
    static var previews: some View {
        CirclesWorkout()
    }
}
