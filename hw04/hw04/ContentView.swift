//
//  ContentView.swift
//  hw04
//
//  Created by Parissa Teli on 9/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        cupPong()
    }
}

struct cupPong: View {
    //@State private var tapped = false
    //@State private var tapLocation: CGPoint = .zero
    
    //Sets up private state variables for ball and obstacle positions... both will contain arrays of location positions
    @State private var smilePosition: [CGPoint] = []
    @State private var angryPosition: [CGPoint] = []
    @State private var genPositions: [CGPoint] = []
    
    //Sets up scale state variables
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    //Sets up animation features
    @State private var pulse = false
    @State private var smileBounce = false
    
    //Initialize background color (can handle color and gradients)
    @State private var background: AnyView = AnyView(
        LinearGradient(
            gradient: Gradient(colors: [.green, .mint]),
            startPoint: .top,
            endPoint: .bottom
        )
    )

    var body: some View{
        ZStack{
            background
                .ignoresSafeArea()
            
            ZStack{
                VStack{
                    Text("Mood Map")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .italic()
                        .padding()
                    Text("Click and swipe to design your mood board!")
                        .font(.caption)
                        .italic()
                }
                
                // For every ball position index, create a red ball
                ForEach(smilePosition.indices, id: \.self){index in
                    Image("smile_yellow")
                        .renderingMode(.template) //treats image as stencil with no color
                        .resizable()
                        .frame(width:50, height:50)
                        .foregroundColor(.pink)
                        .position(smilePosition[index])
                        .scaleEffect(smileBounce ? 1.2 : 1.0)
                        .animation(
                            Animation
                                .interpolatingSpring(stiffness: 200, damping: 5)
                                .repeatForever(autoreverses: true),
                            value: smileBounce
                        )
                }
                
                // For every obstacle position index, create a caution sign
                ForEach(angryPosition.indices, id: \.self){index in
                    Image("angry")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.orange)
                        .position(angryPosition[index])
                        .scaleEffect(pulse ? 1.2 : 1.0)
                        .animation(
                            Animation
                                .easeIn(duration: 0.6)
                                .repeatForever(autoreverses: true),
                            value: pulse
                        )
                        .onAppear {
                            pulse = true
                        }
                }
       /*
                ForEach(genPositions.indices, id: \.self){index in
                    Image("caution")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .position(genPositions[index])
                } */
                
            }
            // Pinch to scale effect on entire screen
            .scaleEffect(currentScale)
        }
        // Pinch to zoom gesture
        .gesture(
            MagnificationGesture()
                // when user pinches, value of scale changes
                .onChanged { value in
                    let newScale = lastScale * value
                    currentScale = min(max(newScale, 1.0), 3.0)  // clamp scale
                }
                .onEnded { _ in
                    lastScale = currentScale
                }
        )
        // Swipe gesture to change background color
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        if horizontalAmount < 0 {
                            // Swipe Left: Pink → Orange
                            background = AnyView(
                                LinearGradient(
                                    gradient: Gradient(colors: [.mint, .mint]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        } else {
                            // Swipe Right:
                            background = AnyView(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .green]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    } else {
                        if verticalAmount < 0 {
                            // Swipe Up
                            background = AnyView(Color.orange)
                        } else {
                            // Swipe Down
                            background = AnyView(Color.pink)
                        }
                    }
                }
        )
        // on long press for 3 seconds, clear the screen
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 3.0)
                .onEnded{ _ in
                    smilePosition.removeAll()
                    angryPosition.removeAll()
                    genPositions.removeAll()
                }
        )
        // when the screen is single tapped, add location of tap to smile position array
        .onTapGesture { location in
            smilePosition.append(location)
            smileBounce = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                smileBounce = true
            }
        }
        // when screen is double tapped, add location of tap to angrey position array
        .onTapGesture(count: 2) { location in
            angryPosition.append(location)
            pulse = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                pulse = true
            }
        }
        // when screen is triple tapped, add location of tap to gen position array
        .onTapGesture(count: 3) { location in
            genPositions.append(location)
        }
        // Trigger smileBounce animation once on appear
        .onAppear {
            smileBounce = true
        }
    }
}


/*
struct TapDemo: View {
    @State private var tapped = false

    var body: some View {
        ZStack {
            // Background color changes based on tap
            (tapped ? Color.green : Color.cyan)
                .ignoresSafeArea()

            // Red circle in center
            Circle()
                .fill(Color.red)
                .frame(width: 60, height: 60)
                .onTapGesture {
                    print("tapped")
                    tapped.toggle()
                }
        }
    }
}
 

struct tapLocation: View {
    @State private var tapLocation: CGPoint = .zero
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .ignoresSafeArea()
                .onTapGesture(coordinateSpace: .local){
                    location in
                    tapLocation = location
                    //tapLocation.x = 5
                    print("location of da tap: \(location)")
                    
                }
            Circle()
                .fill(Color.blue)
            
            }
    }
}

*/

#Preview {
    ContentView()
}
